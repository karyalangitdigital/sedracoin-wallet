import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;

import '../network.dart';
import '../types.dart';
import '../utils.dart';
import 'grpc/grpc_client.dart';
import 'grpc/messages.pbgrpc.dart';
import 'grpc/rpc.pb.dart';
import 'grpc_converters.dart';
import 'rpc_service.dart';

class RpcException implements Exception {
  final RPCError error;

  const RpcException(this.error);

  String get message => error.message;

  @override
  String toString() => message;
}

class GrpcService implements RpcService {
  final GrpcClient client;

  GrpcService({required this.client});

  factory GrpcService.url(String url, {bool tls = true, Duration? timeout}) {
    final components = url.split(':');
    final host = components.first;
    final port = int.tryParse(components.last) ?? (tls ? 443 : kMainnetRpcPort);

    final service = GrpcService(
      client: .host(host, port: port, tls: tls, timeout: timeout),
    );

    return service;
  }

  @override
  Future<void> connect() => client.connect();

  @override
  Future<void> disconnect() => client.close();

  static final _random = Random();
  static Int64 _generateId() => Int64.fromInts(
    _random.nextInt(1 << 31),
    _random.nextInt(1 << 32),
  );

  /// REST API base used as a fallback when the gRPC node is unreachable.
  static const _kRestApiBase = 'https://api.sedracoin.com';

  // Circuit breaker: once the gRPC node proves unreachable we skip gRPC and go
  // straight to the REST fallback for a cooldown period, then probe gRPC again.
  // This avoids a multi-second hang on every call while the node is down.
  bool _grpcDown = false;
  DateTime _grpcRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  static const _grpcCooldown = Duration(seconds: 30);

  bool get _shouldTryGrpc => !_grpcDown || DateTime.now().isAfter(_grpcRetryAt);

  void _markGrpcUp() {
    _grpcDown = false;
  }

  void _markGrpcDown() {
    _grpcDown = true;
    _grpcRetryAt = DateTime.now().add(_grpcCooldown);
  }

  /// Server Info
  @override
  Future<ServerInfo> getServerInfo() async {
    if (_shouldTryGrpc) {
      try {
        final request = SedradRequest(
          id: _generateId(),
          getServerInfoRequest: GetServerInfoRequestMessage(),
        );

        final response = await client.call(request);
        final message = response.getServerInfoResponse;

        if (message.hasError()) {
          throw RpcException(message.error);
        }

        _markGrpcUp();
        return decodeServerInfo(message);
      } catch (e) {
        _markGrpcDown();
        // ignore: avoid_print
        print('gRPC getServerInfo failed: $e, falling back to REST API');
      }
    }

    final url = Uri.parse('$_kRestApiBase/info/network');
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return ServerInfo(
        rpcApiRevision: 0,
        rpcApiVersion: 0,
        serverVersion: 'REST-fallback',
        networkId: parsed['networkName'] ?? 'sedra-mainnet',
        hasUtxoIndex: true,
        isSynced: true,
        virtualDaaScore:
            int.tryParse(parsed['virtualDaaScore']?.toString() ?? '0') ?? 0,
      );
    } else {
      throw Exception(
        'REST getServerInfo failed with ${response.statusCode}: ${response.body}',
      );
    }
  }

  /// Blocks
  @override
  Future<Block> getBlock(String hash, {bool includeTransactions = true}) async {
    final request = SedradRequest(
      id: _generateId(),
      getBlockRequest: GetBlockRequestMessage(
        hash: hash,
        includeTransactions: includeTransactions,
      ),
    );

    final response = await client.call(request);
    final message = response.getBlockResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }

    return decodeBlock(message.block);
  }

  /// Virtual Chain From Block (vspc v2)
  @override
  Future<VirtualChainSegment> getVirtualChainFromBlockV2(
    String startHash, {
    DataVerbosity verbosity = .high,
    int? minConfirmationCount,
  }) async {
    final request = SedradRequest(
      id: _generateId(),
      getVirtualChainFromBlockV2Request:
          GetVirtualChainFromBlockV2RequestMessage(
            startHash: startHash,
            dataVerbosityLevel: encodeDataVerbosity(verbosity),
            minConfirmationCount: minConfirmationCount != null
                ? Int64(minConfirmationCount)
                : null,
          ),
    );

    final response = await client.call(request);
    final message = response.getVirtualChainFromBlockV2Response;

    if (message.hasError()) {
      throw RpcException(message.error);
    }

    return decodeVirtualChainSegment(message);
  }

  /// Balances
  @override
  Future<Iterable<AddressBalance>> getBalancesByAddresses(
    Iterable<String> addresses,
  ) async {
    if (_shouldTryGrpc) {
      try {
        final request = SedradRequest(
          id: _generateId(),
          getBalancesByAddressesRequest: GetBalancesByAddressesRequestMessage(
            addresses: addresses,
          ),
        );

        final response = await client.call(request);
        final message = response.getBalancesByAddressesResponse;

        if (message.hasError()) {
          throw RpcException(message.error);
        }

        _markGrpcUp();
        return message.entries.map(decodeAddressBalance);
      } catch (e) {
        _markGrpcDown();
        // ignore: avoid_print
        print(
          'gRPC getBalancesByAddresses failed: $e, falling back to REST API',
        );
      }
    }

    final results = await Future.wait(
      addresses.map((address) async {
        try {
          final url = Uri.parse(
            '$_kRestApiBase/addresses/$address/balance',
          );
          final response = await http
              .get(url)
              .timeout(const Duration(seconds: 10));
          if (response.statusCode == 200) {
            final parsed = jsonDecode(response.body);
            return AddressBalance(
              address: address,
              balance: BigInt.parse(parsed['balance'].toString()),
            );
          }
        } catch (innerE) {
          // ignore: avoid_print
          print('REST fallback for $address failed: $innerE');
        }
        return null;
      }),
    );
    return results.whereType<AddressBalance>();
  }

  /// Utxos
  @override
  Future<Iterable<Utxo>> getUtxosByAddresses(Iterable<String> addresses) async {
    if (_shouldTryGrpc) {
      try {
        final request = SedradRequest(
          id: _generateId(),
          getUtxosByAddressesRequest: GetUtxosByAddressesRequestMessage(
            addresses: addresses,
          ),
        );

        final response = await client.call(request);
        final message = response.getUtxosByAddressesResponse;

        if (message.hasError()) {
          throw RpcException(message.error);
        }

        _markGrpcUp();
        return message.entries.map(decodeUtxo);
      } catch (e) {
        _markGrpcDown();
        // ignore: avoid_print
        print('gRPC getUtxosByAddresses failed: $e, falling back to REST API');
      }
    }

    final results = await Future.wait(
      addresses.map((address) async {
        final addressUtxos = <Utxo>[];
        try {
          final url = Uri.parse('$_kRestApiBase/addresses/$address/utxos');
          final response = await http
              .get(url)
              .timeout(const Duration(seconds: 10));
          if (response.statusCode == 200) {
            final List<dynamic> jsonList = jsonDecode(response.body);
            for (final item in jsonList) {
              final outpoint = item['outpoint'];
              final utxoEntry = item['utxoEntry'];
              addressUtxos.add(
                Utxo(
                  address: item['address'],
                  outpoint: Outpoint(
                    transactionId: outpoint['transactionId'],
                    index: outpoint['index'],
                  ),
                  utxoEntry: UtxoEntry(
                    amount: BigInt.parse(utxoEntry['amount'].toString()),
                    scriptPublicKey: ScriptPublicKey(
                      scriptPublicKey: hexToBytes(
                        utxoEntry['scriptPublicKey']['scriptPublicKey'],
                      ),
                      version: utxoEntry['scriptPublicKey']['version'] ?? 0,
                    ),
                    blockDaaScore: BigInt.parse(
                      utxoEntry['blockDaaScore'].toString(),
                    ),
                    isCoinbase: utxoEntry['isCoinbase'] ?? false,
                  ),
                ),
              );
            }
          }
        } catch (innerE) {
          // ignore: avoid_print
          print('REST fallback for $address failed: $innerE');
        }
        return addressUtxos;
      }),
    );
    return results.expand((utxos) => utxos);
  }

  /// Mempool
  @override
  Future<Iterable<MempoolEntryByAddress>> getMempoolEntriesByAddresses(
    Iterable<String> addresses, {
    bool filterTransactionPool = false,
    bool includeOrphanPool = false,
  }) async {
    if (!_shouldTryGrpc) {
      return [];
    }
    try {
      final request = SedradRequest(
        id: _generateId(),
        getMempoolEntriesByAddressesRequest:
            GetMempoolEntriesByAddressesRequestMessage(
              addresses: addresses,
              filterTransactionPool: filterTransactionPool,
              includeOrphanPool: includeOrphanPool,
            ),
      );

      final response = await client.call(request);
      final message = response.getMempoolEntriesByAddressesResponse;

      if (message.hasError()) {
        throw RpcException(message.error);
      }

      _markGrpcUp();
      return message.entries.map(decodeMempoolEntryByAddress);
    } catch (e) {
      _markGrpcDown();
      // ignore: avoid_print
      print('gRPC getMempoolEntriesByAddresses failed: $e, ignoring mempool');
      return [];
    }
  }

  /// Fee Estimate
  @override
  Future<FeeEstimate> getFeeEstimate() async {
    if (!_shouldTryGrpc) {
      // Fail fast so callers fall back to their default fee rate instead of
      // waiting for a gRPC timeout.
      throw Exception('gRPC node unavailable');
    }
    try {
      final request = SedradRequest(
        id: _generateId(),
        getFeeEstimateRequest: GetFeeEstimateRequestMessage(),
      );

      final response = await client.call(request);
      final message = response.getFeeEstimateResponse;

      if (message.hasError()) {
        throw RpcException(message.error);
      }

      _markGrpcUp();
      return decodeFeeEstimate(message.estimate);
    } catch (e) {
      _markGrpcDown();
      rethrow;
    }
  }

  /// Submit Transaction
  @override
  Future<String> submitTransaction(
    RawTransaction transaction, {
    bool allowOrphan = false,
  }) async {
    if (_shouldTryGrpc) {
      try {
        final request = SedradRequest(
          id: _generateId(),
          submitTransactionRequest: SubmitTransactionRequestMessage(
            transaction: encodeTransaction(transaction),
            allowOrphan: allowOrphan,
          ),
        );

        final response = await client.call(request);
        final message = response.submitTransactionResponse;

        if (message.hasError()) {
          throw RpcException(message.error);
        }

        _markGrpcUp();
        return message.transactionId;
      } catch (e) {
        _markGrpcDown();
        // ignore: avoid_print
        print('gRPC submitTransaction failed: $e, falling back to REST API');
      }
    }

    {
      final url = Uri.parse('$_kRestApiBase/transactions');
      final reqBody = jsonEncode({
        "transaction": {
          "version": transaction.version,
          "inputs": transaction.inputs
              .map(
                (i) => {
                  "previousOutpoint": {
                    "transactionId": i.previousOutpoint.transactionId,
                    "index": i.previousOutpoint.index,
                  },
                  "signatureScript": bytesToHex(i.signatureScript),
                  "sequence": i.sequence.toInt(),
                  "sigOpCount": i.sigOpCount,
                },
              )
              .toList(),
          "outputs": transaction.outputs
              .map(
                (o) => {
                  "amount": o.value.toInt(),
                  "scriptPublicKey": {
                    "scriptPublicKey": bytesToHex(
                      o.scriptPublicKey.scriptPublicKey,
                    ),
                    "version": o.scriptPublicKey.version,
                  },
                },
              )
              .toList(),
          "lockTime": transaction.lockTime.toInt(),
          "subnetworkId": transaction.subnetworkId.hex,
          "gas": transaction.gas.toInt(),
          "payload": transaction.payload != null
              ? bytesToHex(transaction.payload!)
              : "",
        },
      });
      final res = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: reqBody,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final parsed = jsonDecode(res.body);
        return parsed['transactionId'] ?? 'unknown';
      } else {
        throw Exception(
          'REST submitTransaction failed with ${res.statusCode}: ${res.body}',
        );
      }
    }
  }

  @override
  Future<(String, Transaction)> submitTransactionReplacement(
    RawTransaction transaction,
  ) async {
    final request = SedradRequest(
      id: _generateId(),
      submitTransactionReplacementRequest:
          SubmitTransactionReplacementRequestMessage(
            transaction: encodeTransaction(transaction),
          ),
    );

    final response = await client.call(request);
    final message = response.submitTransactionReplacementResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }

    return (
      message.transactionId,
      decodeTransaction(message.replacedTransaction),
    );
  }

  /// Notifications

  /// Block Added
  @override
  Stream<Block> notifyBlockAdded() {
    final request = SedradRequest(
      id: _generateId(),
      notifyBlockAddedRequest: NotifyBlockAddedRequestMessage(
        command: .NOTIFY_START,
      ),
    );

    return client
        .subscribe(request)
        .notifications
        .map((event) => event.blockAddedNotification.block)
        .map(decodeBlock);
  }

  @override
  Future<void> stopNotifyingBlockAdded() async {
    final request = SedradRequest(
      id: _generateId(),
      notifyBlockAddedRequest: NotifyBlockAddedRequestMessage(
        command: .NOTIFY_STOP,
      ),
    );

    final response = await client.call(request);
    final message = response.notifyBlockAddedResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }
  }

  /// Utxos Changed
  @override
  Stream<UtxosChanged> notifyUtxosChanged(Iterable<String> addresses) {
    if (!_shouldTryGrpc) {
      return _pollUtxosChanged(addresses);
    }
    final request = SedradRequest(
      id: _generateId(),
      notifyUtxosChangedRequest: NotifyUtxosChangedRequestMessage(
        addresses: addresses,
        command: .NOTIFY_START,
      ),
    );

    final grpcStream = client
        .subscribe(request)
        .notifications
        .map((event) => event.utxosChangedNotification)
        .map(decodeUtxosChanged);

    return _withRestPollingFallback(
      grpcStream,
      () => _pollUtxosChanged(addresses),
    );
  }

  @override
  Future<void> stopNotifyingUtxosChanged(Iterable<String> addresses) async {
    final request = SedradRequest(
      id: _generateId(),
      notifyUtxosChangedRequest: NotifyUtxosChangedRequestMessage(
        addresses: addresses,
        command: .NOTIFY_STOP,
      ),
    );

    final response = await client.call(request);
    final message = response.notifyUtxosChangedResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }
  }

  /// Virtual DAA Score Changed
  @override
  Stream<BigInt> notifyVirtualDaaScoreChanged() {
    if (!_shouldTryGrpc) {
      return _pollVirtualDaaScore();
    }
    final request = SedradRequest(
      id: _generateId(),
      notifyVirtualDaaScoreChangedRequest:
          NotifyVirtualDaaScoreChangedRequestMessage(
            command: .NOTIFY_START,
          ),
    );

    final grpcStream = client.subscribe(request).notifications.map((event) {
      final notification = event.virtualDaaScoreChangedNotification;
      return notification.virtualDaaScore.toUnsignedBigInt();
    });

    return _withRestPollingFallback(grpcStream, _pollVirtualDaaScore);
  }

  @override
  Future<void> stopNotifyingVirtualDaaScoreChanged() async {
    final request = SedradRequest(
      id: _generateId(),
      notifyVirtualDaaScoreChangedRequest:
          NotifyVirtualDaaScoreChangedRequestMessage(
            command: .NOTIFY_STOP,
          ),
    );

    final response = await client.call(request);
    final message = response.notifyVirtualDaaScoreChangedResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }
  }

  /// Sink Blue Score Changed
  @override
  Stream<BigInt> notifySinkBlueScoreChanged() {
    final request = SedradRequest(
      id: _generateId(),
      notifySinkBlueScoreChangedRequest:
          NotifySinkBlueScoreChangedRequestMessage(
            command: .NOTIFY_START,
          ),
    );

    return client.subscribe(request).notifications.map((event) {
      final notification = event.sinkBlueScoreChangedNotification;
      return notification.sinkBlueScore.toUnsignedBigInt();
    });
  }

  @override
  Future<void> stopNotifyingSinkBlueScoreChanged() async {
    final request = SedradRequest(
      id: _generateId(),
      notifySinkBlueScoreChangedRequest:
          NotifySinkBlueScoreChangedRequestMessage(
            command: .NOTIFY_STOP,
          ),
    );

    final response = await client.call(request);
    final message = response.notifySinkBlueScoreChangedResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }
  }

  /// Virtual Selected Parent Chain Changed
  @override
  Stream<VirtualChainChanged> notifyVirtualChainChanged({
    bool includeAcceptedTransactionIds = true,
  }) {
    final request = SedradRequest(
      id: _generateId(),
      notifyVirtualChainChangedRequest: NotifyVirtualChainChangedRequestMessage(
        command: .NOTIFY_START,
        includeAcceptedTransactionIds: includeAcceptedTransactionIds,
      ),
    );

    return client
        .subscribe(request)
        .notifications
        .map((event) => event.virtualChainChangedNotification)
        .map(decodeVirtualChainChanged);
  }

  @override
  Future<void> stopNotifyingVirtualChainChanged() async {
    final request = SedradRequest(
      id: _generateId(),
      notifyVirtualChainChangedRequest: NotifyVirtualChainChangedRequestMessage(
        command: .NOTIFY_STOP,
      ),
    );

    final response = await client.call(request);
    final message = response.notifyVirtualChainChangedResponse;

    if (message.hasError()) {
      throw RpcException(message.error);
    }
  }

  // ---------------------------------------------------------------------------
  // REST polling fallbacks for gRPC notification streams.
  //
  // When the gRPC node is unreachable the notification streams never emit, so
  // live updates (balances, UTXOs, transaction history and the DAA score
  // heartbeat) would stop working. These helpers transparently switch to
  // polling the REST API, which keeps the wallet fully functional without gRPC.
  // ---------------------------------------------------------------------------

  static const _utxoPollInterval = Duration(seconds: 20);
  static const _daaPollInterval = Duration(seconds: 15);

  static String _utxoKey(Utxo utxo) =>
      '${utxo.outpoint.transactionId}:${utxo.outpoint.index}';

  /// Emits from [grpcStream]; if it errors or completes (which happens when the
  /// gRPC node is unreachable) it transparently switches to [restPoller].
  Stream<T> _withRestPollingFallback<T>(
    Stream<T> grpcStream,
    Stream<T> Function() restPoller,
  ) {
    late final StreamController<T> controller;
    StreamSubscription<T>? subscription;
    var usingRest = false;

    void startRestFallback() {
      if (usingRest) return;
      usingRest = true;
      subscription = restPoller().listen(
        (data) {
          if (!controller.isClosed) controller.add(data);
        },
        // Keep polling through transient REST errors.
        onError: (_) {},
      );
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = grpcStream.listen(
          (data) {
            if (!controller.isClosed) controller.add(data);
          },
          onError: (_) {
            subscription?.cancel();
            startRestFallback();
          },
          onDone: () {
            if (!usingRest) startRestFallback();
          },
        );
      },
      onCancel: () async {
        await subscription?.cancel();
        subscription = null;
      },
    );

    return controller.stream;
  }

  /// Polls the REST API for the virtual DAA score; used as the app heartbeat
  /// (drives the network status and coinbase maturity checks).
  Stream<BigInt> _pollVirtualDaaScore() async* {
    final url = Uri.parse('$_kRestApiBase/info/network');
    while (true) {
      try {
        final response = await http
            .get(url)
            .timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final parsed = jsonDecode(response.body);
          final daa = BigInt.tryParse(
            parsed['virtualDaaScore']?.toString() ?? '',
          );
          if (daa != null) yield daa;
        }
      } catch (_) {
        // ignore transient errors and keep polling
      }
      await Future<void>.delayed(_daaPollInterval);
    }
  }

  /// Polls the REST API for UTXOs and emits diffs, mimicking the gRPC
  /// notifyUtxosChanged stream. This keeps balances, UTXOs and transaction
  /// history refreshing live even when gRPC is down.
  Stream<UtxosChanged> _pollUtxosChanged(Iterable<String> addresses) async* {
    final addressList = addresses.toList();
    var previous = <String, Utxo>{};
    while (true) {
      try {
        final utxos = (await getUtxosByAddresses(addressList)).toList();
        final current = <String, Utxo>{
          for (final utxo in utxos) _utxoKey(utxo): utxo,
        };

        final added = <Utxo>[
          for (final entry in current.entries)
            if (!previous.containsKey(entry.key)) entry.value,
        ];
        final removed = <Utxo>[
          for (final entry in previous.entries)
            if (!current.containsKey(entry.key)) entry.value,
        ];
        previous = current;

        if (added.isNotEmpty || removed.isNotEmpty) {
          yield UtxosChanged(added: added, removed: removed);
        }
      } catch (_) {
        // ignore transient errors and keep polling
      }
      await Future<void>.delayed(_utxoPollInterval);
    }
  }
}
