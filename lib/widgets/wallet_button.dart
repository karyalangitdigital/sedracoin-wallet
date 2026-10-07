import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../wallet_address/wallet_address.dart';
import 'app_wallet_icon.dart';

class WalletButton extends ConsumerWidget {
  final WalletAddress address;
  final Size size;

  const WalletButton({
    super.key,
    required this.address,
    this.size = const Size(48, 36),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(
        child: AppWalletIcon(
          color: theme.primary,
          size: size.height,
        ),
      ),
    );
  }
}
