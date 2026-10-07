import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../wallet_address/address_details_sheet.dart';
import 'app_wallet_icon.dart';
import 'sheet_util.dart';

class SelectedWalletButton extends ConsumerWidget {
  final Size size;

  const SelectedWalletButton({
    super.key,
    this.size = const Size(36, 36),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);

    final account = ref.watch(receiveAddressProvider);

    void showAccountDetails() {
      Sheets.showAppHeightNineSheet(
        context: context,
        theme: theme,
        widget: AddressDetailsSheet(address: account),
      );
    }

    return SizedBox(
      width: size.width,
      height: size.height,
      child: TextButton(
        style: styles.walletButtonStyle,
        onPressed: showAccountDetails,
        child: Center(
          child: AppWalletIcon(
            color: theme.success,
            size: 28,
          ),
        ),
      ),
    );
  }
}
