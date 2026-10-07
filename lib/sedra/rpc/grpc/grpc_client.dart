import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../../network.dart';
import 'messages.pbgrpc.dart';

const _defaultTimeout = Duration(seconds: 10);

// Fail fast when the gRPC endpoint is unreachable so the REST fallback can
// kick in quickly instead of waiting for the OS level TCP timeout.
const _connectTimeout = Duration(seconds: 8);

typedef GrpcSubscription = ({
  Future<SedradResponse> response,
  Stream<SedradResponse> notifications,
});

class GrpcClient {
  final String? host;
  final int? port;
  final bool tls;
  final Duration timeout;

  ClientChannel _channel;
  RPCClient _rpcClient;

  ClientChannel get channel => _channel;
  RPCClient get rpcClient => _rpcClient;

  StreamSubscription<SedradResponse>? _connection;

  final _responders = <Int64, Completer<SedradResponse>>{};
  final _subscriptions = <String, StreamController<SedradResponse>>{};

  StreamController<SedradRequest> _requestController =
      StreamController<SedradRequest>();

  GrpcClient({
    ClientChannel? channel,
    this.host,
    this.port,
    this.tls = false,
    Duration? timeout,
  }) : _channel =
           channel ??
           ClientChannel(
             host ?? 'localhost',
             port: port ?? kMainnetRpcPort,
             options: ChannelOptions(
               credentials: tls
                   ? const ChannelCredentials.secure()
                   : const ChannelCredentials.insecure(),
               connectTimeout: _connectTimeout,
             ),
           ),
       _rpcClient = RPCClient(
         channel ??
             ClientChannel(
               host ?? 'localhost',
               port: port ?? kMainnetRpcPort,
               options: ChannelOptions(
                 credentials: tls
                     ? const ChannelCredentials.secure()
                     : const ChannelCredentials.insecure(),
                 connectTimeout: _connectTimeout,
               ),
             ),
       ),
       timeout = timeout ?? _defaultTimeout;

  factory GrpcClient.host(
    String host, {
    required int port,
    bool tls = false,
    Duration? timeout,
  }) {
    return GrpcClient(
      host: host,
      port: port,
      tls: tls,
      timeout: timeout,
    );
  }

  void _reinitChannel() {
    if (host != null && port != null) {
      _channel = ClientChannel(
        host!,
        port: port!,
        options: ChannelOptions(
          credentials: tls
              ? const ChannelCredentials.secure()
              : const ChannelCredentials.insecure(),
          connectTimeout: _connectTimeout,
        ),
      );
      _rpcClient = RPCClient(_channel);
    }
  }

  SedradResponse_Payload _convertToNotificationPayload(
    SedradRequest_Payload payload,
  ) {
    return switch (payload) {
      .notifyBlockAddedRequest => .blockAddedNotification,
      .notifyUtxosChangedRequest => .utxosChangedNotification,
      .notifyVirtualDaaScoreChangedRequest =>
        .virtualDaaScoreChangedNotification,
      .notifySinkBlueScoreChangedRequest => .sinkBlueScoreChangedNotification,
      .notifyVirtualChainChangedRequest => .virtualChainChangedNotification,
      _ => throw Exception('Unsuported payload: $payload'),
    };
  }

  Future<void> connect() async {
    if (_connection != null) {
      return;
    }

    if (_requestController.isClosed) {
      _requestController = StreamController<SedradRequest>();
    }

    _connection = _rpcClient
        .messageStream(_requestController.stream)
        .listen(
          (message) {
            if (message.hasId()) {
              // response
              final completer = _responders.remove(message.id);
              completer?.complete(message);
            } else {
              // notification
              final notification = message.whichPayload();
              _subscriptions[notification.name]?.add(message);
            }
          },
          onError: (error) {
            // ignore: avoid_print
            print('gRPC stream error: $error');
            close();
          },
          onDone: () {
            close();
          },
        );
  }

  Future<void> close() async {
    _connection?.cancel();
    _connection = null;
    _responders.forEach(
      (_, value) {
        if (!value.isCompleted) {
          value.completeError(Exception('Connection closed'));
        }
      },
    );
    _responders.clear();
    _subscriptions.forEach((_, value) => value.close());
    _subscriptions.clear();

    final oldChannel = _channel;
    _reinitChannel();

    if (!_requestController.isClosed) {
      _requestController.close().ignore();
    }
    _requestController = StreamController<SedradRequest>();

    return oldChannel.shutdown();
  }

  Future<SedradResponse> call(SedradRequest request) async {
    if (_connection == null) {
      await connect();
    }
    final completer = Completer<SedradResponse>();
    _responders[request.id] = completer;
    completer.future.ignore();

    _requestController.add(request);

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _responders.remove(request.id);
        throw TimeoutException('$request: id ${request.id}', timeout);
      },
    );
  }

  GrpcSubscription subscribe(SedradRequest request) {
    final payload = request.whichPayload();
    final notification = _convertToNotificationPayload(payload);

    // close previous subscription if any
    _subscriptions[notification.name]?.close();

    final controller = StreamController<SedradResponse>();
    _subscriptions[notification.name] = controller;

    final response = call(request);
    response.ignore();

    return (
      response: response,
      notifications: controller.stream,
    );
  }
}
