import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings_repository.dart';
import 'node_types.dart';

const kNodeConfigKey = '_kNodeConfigKeyV2';

extension NodeSettingsExtension on SettingsRepository {
  NodeConfigSettings getNodeConfigSettings() {
    final settings = box.tryGet<NodeConfigSettings>(
      kNodeConfigKey,
      typeFactory: NodeConfigSettings.fromJson,
    );
    if (settings == null) {
      return const NodeConfigSettings();
    }
    final options = settings.options.map((option) {
      if (option.id == mainnetNodeConfig.id) {
        return mainnetNodeConfig;
      }
      return option;
    }).toIList();
    final selected = settings.selected.id == mainnetNodeConfig.id
        ? mainnetNodeConfig
        : settings.selected;
    return settings.copyWith(options: options, selected: selected);
  }

  Future<void> setNodeConfigSettings(NodeConfigSettings settings) {
    return box.set(kNodeConfigKey, settings);
  }
}

class NodeSettingsNotifier extends StateNotifier<NodeConfigSettings> {
  final SettingsRepository repository;

  NodeSettingsNotifier(this.repository)
    : super(repository.getNodeConfigSettings());

  Future<void> updateSelected(NodeConfig config) {
    state = state.copyWith(selected: config);
    return repository.setNodeConfigSettings(state);
  }

  Future<void> updateOptions(IList<NodeConfig> options) {
    state = state.copyWith(
      options: options,
    );
    return repository.setNodeConfigSettings(state);
  }

  Future<bool> addOption(NodeConfig config) async {
    if (state.options.contains(config)) {
      return false;
    }
    final options = state.options.add(config);
    await updateOptions(options);
    return true;
  }

  Future<bool> removeOption(NodeConfig config) async {
    if (config == state.selected) {
      return false;
    }
    final options = state.options.remove(config);
    await updateOptions(options);
    return true;
  }
}
