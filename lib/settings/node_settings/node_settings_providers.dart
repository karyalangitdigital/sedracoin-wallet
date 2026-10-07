import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings_providers.dart';
import 'node_settings_notifier.dart';
import 'node_types.dart';

final sedraNodeSettingsProvider =
    StateNotifierProvider<NodeSettingsNotifier, NodeConfigSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  final notifier = NodeSettingsNotifier(repository);
  return notifier;
});

final sedraNodeOptionsProvider = Provider((ref) {
  final settings = ref.watch(sedraNodeSettingsProvider);
  return settings.options;
});

final sedraNodeConfigProvider = Provider((ref) {
  final settings = ref.watch(sedraNodeSettingsProvider);
  return ActiveNodeConfig(config: settings.selected);
});
