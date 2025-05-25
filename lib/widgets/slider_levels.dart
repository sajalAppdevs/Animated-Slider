import 'package:flutter/material.dart';
import 'computed_text.dart';

const Duration _animationDuration = Duration(milliseconds: 100);
const double _labelsHorizontalMargins = 12.0;

class SliderLabels extends StatelessWidget {
  final int progressPercent;
  final TextStyle style;
  final double height;
  final double width;
  final ValueNotifier<bool> isOverflowing;
  final void Function(double) onSizeChange;

  const SliderLabels({
    super.key,
    required this.progressPercent,
    required this.style,
    required this.height,
    required this.width,
    required this.isOverflowing,
    required this.onSizeChange,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isOverflowing,
      builder: (context, overflowing, child) {
        return AnimatedPositioned.fromRect(
          duration: _animationDuration,
          rect: Rect.fromCenter(
            width: width,
            height: height,
            center: Offset(width / 2, height / (overflowing ? -2 : 2)),
          ),
          child: child!,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _labelsHorizontalMargins),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ComputedText(
              '$progressPercent%',
              style: style,
              onSizeChange: onSizeChange,
            ),
            ComputedText(
              '${100 - progressPercent}%',
              style: style,
              onSizeChange: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
