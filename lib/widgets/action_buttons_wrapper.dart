import 'package:flutter/widgets.dart';

class ActionButtonsWrapper extends StatelessWidget {
  final List<Widget> buttons;

  const ActionButtonsWrapper({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    final child = switch (buttons.length) {
      0 => const SizedBox(),
      1 => buttons.first,
      2 => Row(
        children: [
          Expanded(child: buttons[0]),
          const SizedBox(width: 14),
          Expanded(child: buttons[1]),
        ],
      ),
      _ => Column(
        children: [
          for (int i = 0; i < buttons.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 12),
            if (i + 1 < buttons.length)
              Row(
                children: [
                  Expanded(child: buttons[i]),
                  const SizedBox(width: 14),
                  Expanded(child: buttons[i + 1]),
                ],
              )
            else
              buttons[i],
          ],
        ],
      ),
    };

    return Padding(
      padding: const .symmetric(horizontal: 20, vertical: 16),
      child: child,
    );
  }
}
