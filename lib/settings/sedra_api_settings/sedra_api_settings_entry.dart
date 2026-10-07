import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reicon_flutter/reicon_flutter.dart';

import '../../core/core_providers.dart';
import '../../settings_drawer/double_line_item.dart';
import '../../widgets/sheet_util.dart';
import '../setting_item.dart';
import 'sedra_api_settings_providers.dart';
import 'sedra_api_settings_sheet.dart';

class SedraApiSettingsUrlEntry extends ConsumerWidget {
  const SedraApiSettingsUrlEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sedraApiUrl = ref.watch(sedraApiUrlProvider);

    void changeSedraApiUrl() {
      final theme = ref.read(themeProvider);
      Sheets.showAppHeightEightSheet(
        context: context,
        theme: theme,
        widget: const SedraApiSettingsSheet(),
      );
    }

    final schemeIndex = sedraApiUrl.indexOf('://');
    final displayUrl = schemeIndex != -1
        ? sedraApiUrl.substring(schemeIndex + 3)
        : sedraApiUrl;

    return DoubleLineItem(
      heading: 'Sedra API',
      defaultMethod: StringSelectionItem(displayUrl),
      reiconPath: Reicon.outline.link,
      onPressed: changeSedraApiUrl,
    );
  }
}
