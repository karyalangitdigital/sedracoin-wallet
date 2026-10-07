import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_providers.dart';
import '../l10n/l10n.dart';
import '../settings_drawer/settings_header.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/drawer_wrapper.dart';
import '../widgets/gradient_widgets.dart';
import '../widgets/reicon_chevron.dart';
import 'address_discovery_settings_entry.dart';
import 'compound_utxos_settings_entry.dart';
import 'kpub_settings_entry.dart';
import 'sign_message_settings_entry.dart';
import 'tx_filter_settings_entry.dart';
import 'tx_report_settings_entry.dart';

class AdvancedMenu extends ConsumerWidget {
  final VoidCallback onBackAction;

  const AdvancedMenu({super.key, required this.onBackAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);
    final l10n = l10nOf(context);

    final wallet = ref.watch(walletProvider);

    final items = <Widget>[
      SettingsHeader(title: l10n.manage),
      if (!wallet.isViewOnly) const CompoundUtxosSettingsEntry(),
      const AddressDiscoverySettingsEntry(),
      if (wallet.hasValidKpub) const KpubSettingsEntry(),
      const TxReportSettingsEntry(),
      const TxFilterSettingsEntry(),
      if (!wallet.isViewOnly) const SignMessageSettingsEntry(),
    ];

    return DrawerWrapper(
      child: Column(
        children: [
          Container(
            margin: const .only(bottom: 10, top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const .symmetric(horizontal: 10),
                  child: AppIconButton(
                    iconWidget: ReiconChevron.left(color: theme.text, size: 18),
                    onPressed: onBackAction,
                  ),
                ),
                Text(
                  l10n.advancedHeader,
                  style: styles.textStyleSettingsHeader,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.separated(
                  padding: const .only(top: 15),
                  separatorBuilder: (_, _) => const SizedBox.shrink(),
                  itemCount: items.length,
                  itemBuilder: (_, index) => items[index],
                ),
                const ListBottomGradient(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
