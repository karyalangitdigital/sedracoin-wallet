import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../app_router.dart';
import '../l10n/l10n.dart';
import '../widgets/app_logout_icon.dart';
import '../widgets/dialog.dart';
import 'single_line_item.dart';

class LogoutSettingsItem extends ConsumerWidget {
  const LogoutSettingsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nOf(context);
    final theme = ref.watch(themeProvider);

    void logout() => AppDialogs.showConfirmDialog(
      context,
      l10n.areYouSure,
      l10n.logoutDialogContent,
      l10n.yesUppercase,
      () => appRouter.logout(context),
    );

    return SingleLineItem(
      heading: l10n.logoutOrSwitchWallet,
      iconWidget: AppLogoutIcon(color: theme.primary, size: 24),
      onPressed: logout,
    );
  }
}
