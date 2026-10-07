import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';
import '../settings/available_language.dart';
import '../widgets/app_language_icon.dart';
import 'double_line_item.dart';
import 'language_dialog.dart';

class LanguageSettingsItem extends ConsumerWidget {
  const LanguageSettingsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final theme = ref.watch(themeProvider);
    final l10n = l10nOf(context);

    Future<void> showLanguageDialog() async {
      final selection = await showDialog<AvailableLanguage>(
        context: context,
        builder: (_) => const LanguageDialog(),
      );

      if (selection != null) {
        final notifier = ref.read(languageProvider.notifier);
        notifier.updateLanguage(LanguageSetting(selection));
      }
    }

    return DoubleLineItem(
      heading: l10n.language,
      defaultMethod: language,
      iconWidget: AppLanguageIcon(color: theme.primary, size: 24),
      onPressed: showLanguageDialog,
    );
  }
}
