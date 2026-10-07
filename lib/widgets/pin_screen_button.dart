import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';

class PinScreenButton extends ConsumerWidget {
  final String text;
  final double size;
  final void Function(String text) onTap;

  const PinScreenButton({
    super.key,
    required this.text,
    this.size = 100,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styles = ref.watch(stylesProvider);

    return SizedBox(
      height: size,
      width: size,
      child: InkResponse(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          ref.read(hapticUtilProvider).tap();
          onTap(text);
        },
        child: Container(
          alignment: .center,
          child: Text(
            text,
            textAlign: .center,
            style: styles.textStyleButtonPrimaryOutline.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
