import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';
import '../settings/available_themes.dart';
import '../widgets/app_theme_icon.dart';
import 'double_line_item.dart';
import 'theme_dialog.dart';

class ThemeSettingsItem extends ConsumerWidget {
  const ThemeSettingsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSetting = ref.watch(themeSettingProvider);
    final theme = ref.watch(themeProvider);
    final l10n = l10nOf(context);

    Future<void> showThemeDialog() async {
      final selection = await showDialog<ThemeOptions>(
        context: context,
        builder: (_) => const ThemeDialog(),
      );

      if (selection != null) {
        final notifier = ref.read(themeSettingProvider.notifier);
        notifier.updateTheme(ThemeSetting(selection));
      }
    }

    return DoubleLineItem(
      heading: l10n.themeHeader,
      defaultMethod: themeSetting,
      iconWidget: AppThemeIcon(color: theme.primary, size: 24),
      onPressed: showThemeDialog,
    );
  }
}
