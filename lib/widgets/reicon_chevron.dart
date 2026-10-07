import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reicon_flutter/reicon_flutter.dart';

enum ChevronDirection {
  left,
  right,
  up,
  down,
}

class ReiconChevron extends StatelessWidget {
  final ChevronDirection direction;
  final double size;
  final Color? color;

  const ReiconChevron({
    super.key,
    this.direction = ChevronDirection.left,
    this.size = 18,
    this.color,
  });

  const ReiconChevron.left({
    super.key,
    this.size = 18,
    this.color,
  }) : direction = ChevronDirection.left;

  const ReiconChevron.right({
    super.key,
    this.size = 18,
    this.color,
  }) : direction = ChevronDirection.right;

  const ReiconChevron.up({
    super.key,
    this.size = 18,
    this.color,
  }) : direction = ChevronDirection.up;

  const ReiconChevron.down({
    super.key,
    this.size = 18,
    this.color,
  }) : direction = ChevronDirection.down;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? IconTheme.of(context).color ?? Colors.white;
    final pathData = switch (direction) {
      ChevronDirection.left => Reicon.outline.chevronLeft,
      ChevronDirection.right => Reicon.outline.chevronRight,
      ChevronDirection.up => Reicon.outline.chevronUp,
      ChevronDirection.down => Reicon.outline.chevronDown,
    };

    return SvgPicture.string(
      reiconSvg(pathData, size: size.toInt()),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}
