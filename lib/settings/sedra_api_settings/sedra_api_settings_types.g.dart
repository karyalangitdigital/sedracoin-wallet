// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sedra_api_settings_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SedraApiSettings _$SedraApiSettingsFromJson(Map json) => _SedraApiSettings(
  apiUrlByNetworkId:
      (json['apiUrlByNetworkId'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$SedraApiSettingsToJson(_SedraApiSettings instance) =>
    <String, dynamic>{'apiUrlByNetworkId': instance.apiUrlByNetworkId};
