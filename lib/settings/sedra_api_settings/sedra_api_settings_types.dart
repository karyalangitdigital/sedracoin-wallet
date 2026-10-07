import 'package:freezed_annotation/freezed_annotation.dart';

import '../../sedra/network.dart';

part 'sedra_api_settings_types.freezed.dart';
part 'sedra_api_settings_types.g.dart';

const kSedraApiUrlMainnet = 'https://api.sedracoin.com';
const kSedraApiUrlTestnet10 = 'https://api-testnet.sedracoin.com';

@freezed
sealed class SedraApiSettings with _$SedraApiSettings {
  const SedraApiSettings._();

  const factory SedraApiSettings({
    @Default({}) Map<String, String> apiUrlByNetworkId,
  }) = _SedraApiSettings;

  factory SedraApiSettings.fromJson(Map<String, dynamic> json) =>
      _$SedraApiSettingsFromJson(json);

  static String defaultApiUrlForNetworkId(String networkId) {
    return switch (networkId) {
      kSedraNetworkIdMainnet => kSedraApiUrlMainnet,
      kSedraNetworkIdTestnet10 => kSedraApiUrlTestnet10,
      _ => '',
    };
  }

  String apiUrlForNetworkId(String networkId) {
    return apiUrlByNetworkId[networkId] ?? defaultApiUrlForNetworkId(networkId);
  }
}
