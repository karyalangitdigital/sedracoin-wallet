import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_providers.dart';
import '../widgets/reicon_chevron.dart';
import 'intro_providers.dart';

class IntroBackButton extends ConsumerWidget {
  const IntroBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final styles = ref.watch(stylesProvider);

    void goBack() {
      ref.read(hapticUtilProvider).tap();
      final intro = ref.read(introStateProvider.notifier);
      intro.goBack();
    }

    return SizedBox(
      height: 50,
      width: 50,
      child: TextButton(
        style: styles.roundedTextButtonStyle,
        onPressed: goBack,
        child: ReiconChevron.left(
          color: theme.text,
          size: 18,
        ),
      ),
    );
  }
}
