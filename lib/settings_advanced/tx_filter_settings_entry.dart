import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reicon_flutter/reicon_flutter.dart';

import '../l10n/l10n.dart';
import '../settings/tx_settings.dart';
import '../settings_drawer/double_line_item_two.dart';
import '../transactions/tx_filter_dialog.dart';

class TxFilterSettingsEntry extends ConsumerWidget {
  const TxFilterSettingsEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nOf(context);

    final txFilter = ref.watch(txFilterProvider);

    final txFilterSelectedOption = switch (txFilter) {
      TxFilter.all => l10n.txFilterDialogOptionAllTxs,
      TxFilter.hideNotAcceptedCoinbase =>
        l10n.txFilterDialogOptionHideNotAcceptedCoinbase,
    };

    return DoubleLineItemTwo(
      heading: l10n.txFilterDialogTitle,
      text: txFilterSelectedOption,
      reiconPath: Reicon.outline.documentFilter,
      onPressed: () => showTxFilterDialog(context, ref),
    );
  }
}
