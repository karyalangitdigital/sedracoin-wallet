import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';
import '../settings/available_currency.dart';
import '../widgets/app_currency_icon.dart';
import 'currency_dialog.dart';
import 'double_line_item.dart';

class CurrencySettingsItem extends ConsumerWidget {
  const CurrencySettingsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final theme = ref.watch(themeProvider);
    final l10n = l10nOf(context);

    Future<void> showCurrencyDialog() async {
      final selection = await showDialog<AvailableCurrencies>(
        context: context,
        builder: (_) => const CurrencyDialog(),
      );

      if (selection != null) {
        final notifier = ref.read(currencyProvider.notifier);
        notifier.updateCurrency(AvailableCurrency(selection));
      }
    }

    return DoubleLineItem(
      heading: l10n.currency,
      defaultMethod: currency,
      iconWidget: AppCurrencyIcon(color: theme.primary, size: 24),
      onPressed: showCurrencyDialog,
    );
  }
}
