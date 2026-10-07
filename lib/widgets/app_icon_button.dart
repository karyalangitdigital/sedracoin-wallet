import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';

class AppIconButton extends ConsumerWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Size size;
  final Color? color;
  final VoidCallback? onPressed;

  const AppIconButton({
    super.key,
    this.icon,
    this.iconWidget,
    this.size = const Size(40, 40),
    this.color,
    required this.onPressed,
  }) : assert(icon != null || iconWidget != null, 'Either icon or iconWidget must be provided');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);

    return SizedBox(
      height: size.height,
      width: size.width,
      child: TextButton(
        style: styles.appIconButtonStyle,
        onPressed: () {
          ref.read(hapticUtilProvider).tap();
          onPressed?.call();
        },
        child: iconWidget ?? Icon(icon!, color: color ?? theme.text),
      ),
    );
  }
}
