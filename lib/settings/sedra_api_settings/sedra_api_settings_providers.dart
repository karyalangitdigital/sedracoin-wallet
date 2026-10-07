import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_providers.dart';
import '../settings_providers.dart';
import 'sedra_api_settings_notifier.dart';
import 'sedra_api_settings_types.dart';

final sedraApiSettingsProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SedraApiSettingsNotifier(repository);
});

final sedraApiDefaultUrlProvider = Provider.autoDispose((ref) {
  final networkId = ref.watch(networkIdProvider);

  final apiUrl = SedraApiSettings.defaultApiUrlForNetworkId(networkId);

  return apiUrl;
});

final sedraApiUrlProvider = Provider.autoDispose((ref) {
  final settings = ref.watch(sedraApiSettingsProvider);
  final networkId = ref.watch(networkIdProvider);

  final apiUrl = settings.apiUrlForNetworkId(networkId);

  return apiUrl;
});

final sedraApiUserSetUrlProvider = Provider.autoDispose((ref) {
  final defaultApiUrl = ref.watch(sedraApiDefaultUrlProvider);
  final apiUrl = ref.watch(sedraApiUrlProvider);

  return apiUrl == defaultApiUrl ? '' : apiUrl;
});
