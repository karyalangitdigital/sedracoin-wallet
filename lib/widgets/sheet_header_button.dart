import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';

class SheetHeaderButton extends ConsumerWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final bool visible;
  final VoidCallback? onPressed;

  const SheetHeaderButton({
    super.key,
    this.icon,
    this.iconWidget,
    this.visible = true,
    required this.onPressed,
  }) : assert(icon != null || iconWidget != null, 'Either icon or iconWidget must be provided');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);

    return SizedBox(
      width: 50,
      height: 50,
      child: Visibility(
        visible: visible,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: TextButton(
          style: styles.sheetHeaderButtonStyle,
          onPressed: () {
            ref.read(hapticUtilProvider).tap();
            onPressed?.call();
          },
          child: iconWidget ?? Icon(icon!, size: 24, color: theme.text),
        ),
      ),
    );
  }
}
