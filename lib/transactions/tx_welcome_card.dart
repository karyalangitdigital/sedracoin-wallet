import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';

class TxWelcomeCard extends ConsumerWidget {
  const TxWelcomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Container(
      margin: .fromSTEB(14, 4, 14, 4),
      decoration: BoxDecoration(
        color: theme.backgroundDark,
        borderRadius: .circular(10),
        border: Border.all(color: theme.text15, width: 0.5),
        boxShadow: [theme.boxShadow],
      ),
      child: Container(
        padding: const .symmetric(vertical: 14, horizontal: 15),
        child: RichText(
          textAlign: .center,
          text: _getExampleHeaderSpan(context, ref),
        ),
      ),
    );
  }

  TextSpan _getExampleHeaderSpan(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(stylesProvider);
    final l10n = l10nOf(context);

    final workingStr = l10n.exampleCardIntro;

    if (!workingStr.contains('SEDRA')) {
      return TextSpan(
        text: workingStr,
        style: styles.textStyleTransactionWelcome,
      );
    }
    // Colorize Vite
    List<String> splitStr = workingStr.split('SEDRA');
    if (splitStr.length != 2) {
      return TextSpan(
        text: workingStr,
        style: styles.textStyleTransactionWelcome,
      );
    }
    return TextSpan(
      children: [
        TextSpan(
          text: splitStr[0],
          style: styles.textStyleTransactionWelcome,
        ),
        TextSpan(
          text: 'SEDRA',
          style: styles.textStyleTransactionWelcomePrimary,
        ),
        TextSpan(
          text: splitStr[1],
          style: styles.textStyleTransactionWelcome,
        ),
      ],
    );
  }
}
