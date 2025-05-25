import 'package:flutter/material.dart';

class ComputedText extends StatefulWidget {
  const ComputedText(
      this.text, {
        super.key,
        required this.style,
        this.onSizeChange,
      });

  final String text;
  final TextStyle style;
  final void Function(double textWidth)? onSizeChange;

  @override
  State<ComputedText> createState() => _ComputedTextState();
}

class _ComputedTextState extends State<ComputedText> {
  Size _calculateSize() {
    final textLayout = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      textDirection: TextDirection.ltr,
    )..layout();
    return textLayout.size;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSizeChange?.call(_calculateSize().width);
    });
  }

  @override
  void didUpdateWidget(covariant ComputedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSizeChange?.call(_calculateSize().width);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: widget.style);
  }
}
