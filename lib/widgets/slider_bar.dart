import 'package:flutter/material.dart';

const double _barHorizontalMargins = 6.0;

class SliderBar extends StatelessWidget {
  final double width;
  final Color color;
  final BorderRadius cornerRadius;

  const SliderBar({
    super.key,
    required this.width,
    required this.color,
    required this.cornerRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: cornerRadius,
      ),
      margin: const EdgeInsets.symmetric(horizontal: _barHorizontalMargins),
    );
  }
}
