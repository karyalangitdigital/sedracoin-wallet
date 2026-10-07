import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings_repository.dart';
import 'sedra_api_settings_types.dart';

const kSedraApiSettingsKey = '_kSedraApiSettingsKey';

extension SedraApiSettingsExtension on SettingsRepository {
  SedraApiSettings getSedraApiSettings() {
    final settings = box.tryGet<SedraApiSettings>(
      kSedraApiSettingsKey,
      typeFactory: SedraApiSettings.fromJson,
    );
    if (settings == null) {
      return const SedraApiSettings();
    }
    final cleaned = Map<String, String>.from(settings.apiUrlByNetworkId);
    cleaned.removeWhere((k, v) =>
        v.contains('sedra.org') ||
        v.contains('sedranet.io') ||
        v.contains('katnip'));
    return settings.copyWith(apiUrlByNetworkId: cleaned);
  }

  Future<void> setSedraApiSettings(SedraApiSettings settings) {
    return box.set(kSedraApiSettingsKey, settings);
  }
}

class SedraApiSettingsNotifier extends StateNotifier<SedraApiSettings> {
  final SettingsRepository repository;
  SedraApiSettingsNotifier(this.repository)
      : super(repository.getSedraApiSettings());

  Future<void> setApiUrl(
    String apiUrl, {
    required String networkId,
  }) async {
    if (state.apiUrlForNetworkId(networkId) == apiUrl) {
      return;
    }

    final apiUrlByNetworkId = {
      ...state.apiUrlByNetworkId,
      networkId: apiUrl,
    };

    if (apiUrl.isEmpty) {
      apiUrlByNetworkId.remove(networkId);
    }

    final settings = state.copyWith(apiUrlByNetworkId: apiUrlByNetworkId);

    await repository.setSedraApiSettings(settings);
    state = settings;
  }
}
