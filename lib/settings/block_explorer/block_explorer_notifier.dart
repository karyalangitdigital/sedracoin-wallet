import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings_repository.dart';
import 'block_explorer_settings.dart';
import 'block_explorers.dart';

const _kBlockExplorerConfigKey = '_kBlockExplorerConfigKeyV2';

extension BlockExplorerSettingsExtension on SettingsRepository {
  BlockExplorerSettings getBlockExplorerSettings() {
    final settings = box.tryGet<BlockExplorerSettings>(
      _kBlockExplorerConfigKey,
      typeFactory: BlockExplorerSettings.fromJson,
    );
    if (settings == null) {
      return const BlockExplorerSettings();
    }
    final selection = Map<String, BlockExplorer>.from(settings.selection);
    selection.removeWhere((k, v) =>
        v.url.contains('sedra.org') ||
        v.url.contains('kas.fyi') ||
        v.url.contains('katnip'));
    return settings.copyWith(selection: selection);
  }

  Future<void> setBlockExplorerSettings(BlockExplorerSettings settings) {
    return box.set(_kBlockExplorerConfigKey, settings);
  }
}

class BlockExplorerNotifier extends StateNotifier<BlockExplorerSettings> {
  final SettingsRepository repository;

  BlockExplorerNotifier(this.repository)
      : super(repository.getBlockExplorerSettings());

  Future<void> updateBlockExplorer(
    BlockExplorer explorer, {
    required String networkId,
  }) {
    final selection = Map.of(state.selection);
    selection[networkId] = explorer;
    state = state.copyWith(
      selection: selection,
    );
    return repository.setBlockExplorerSettings(state);
  }
}
