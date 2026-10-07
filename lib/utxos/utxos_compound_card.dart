import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';
import '../util/ui_util.dart';

class UtxosCompoundCard extends ConsumerWidget {
  const UtxosCompoundCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);
    final l10n = l10nOf(context);

    final utxoCount = ref.watch(
      spendableUtxosProvider.select((utxos) => utxos.length),
    );

    void compound() {
      UIUtil.showCompoundFlow(context, ref: ref);
    }

    return Container(
      margin: const .fromSTEB(14, 4, 14, 4),
      decoration: BoxDecoration(
        color: theme.backgroundDark,
        borderRadius: .circular(10),
        border: Border.all(color: theme.text15, width: 0.5),
        boxShadow: [theme.boxShadow],
      ),
      child: TextButton(
        style: styles.cardButtonStyle,
        onPressed: compound,
        child: Padding(
          padding: const .symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Text(
                l10n.utxoCompoundCardTitle,
                maxLines: 1,
                overflow: .ellipsis,
                textAlign: .center,
                style: styles.textStyleSettingItemHeader,
              ),
              const SizedBox(height: 2),
              Text(
                l10n.utxoCompoundCardDescription(utxoCount),
                maxLines: 2,
                overflow: .ellipsis,
                textAlign: .center,
                style: styles.textStyleTransactionWelcome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
