import 'package:freezed_annotation/freezed_annotation.dart';

import '../../sedra/sedra.dart';

part 'block_explorers.freezed.dart';
part 'block_explorers.g.dart';

const kParamPattern = '{0}';

@freezed
sealed class BlockExplorer with _$BlockExplorer {
  const BlockExplorer._();
  const factory BlockExplorer({
    required SedraNetwork network,
    required String name,
    required String url,
    required String addressUrl,
    required String txUrl,
  }) = _BlockExplorer;

  String urlForAddress(String address) =>
      addressUrl.replaceFirst(kParamPattern, address);

  String urlForTx(String hash) => txUrl.replaceFirst(kParamPattern, hash);

  factory BlockExplorer.fromJson(Map<String, dynamic> json) =>
      _$BlockExplorerFromJson(json);
}

const kSedraExplorerMainnet = BlockExplorer(
  network: .mainnet,
  name: 'Sedra Explorer',
  url: 'explorer.sedracoin.com',
  addressUrl: 'https://explorer.sedracoin.com/addresses/$kParamPattern',
  txUrl: 'https://explorer.sedracoin.com/txs/$kParamPattern',
);

const kSedraExplorerTestnet10 = BlockExplorer(
  network: .testnet,
  name: 'Sedra Testnet Explorer',
  url: 'testnet-explorer.sedracoin.com',
  addressUrl: 'https://testnet-explorer.sedracoin.com/addresses/$kParamPattern',
  txUrl: 'https://testnet-explorer.sedracoin.com/txs/$kParamPattern',
);

const kBlockExplorersOptions = <String, List<BlockExplorer>>{
  kSedraNetworkIdMainnet: [
    kSedraExplorerMainnet,
  ],
  kSedraNetworkIdTestnet10: [
    kSedraExplorerTestnet10,
  ],
  kSedraNetworkIdDevnet: [],
  kSedraNetworkIdSimnet: [],
};
