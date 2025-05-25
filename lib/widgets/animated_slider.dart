import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slider/widgets/slider_levels.dart';
import 'slider_bar.dart';


class AnimatedSlider extends StatefulWidget {
  AnimatedSlider({
    super.key,
    this.value = 0.0,
    this.barColor = Colors.white,
    this.rightFillColor = const Color.fromARGB(255, 86, 21, 198),
    this.leftFillColor = Colors.white12,
    this.height = 50.0,
    this.barWidth = 6.0,
    this.onChange,
    this.labelStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w800,
    ),
    BorderRadius? cornerRadius,
  })  : _cornerRadius = cornerRadius ?? BorderRadius.circular(8.0),
        assert(value >= 0 && value <= 1.0);

  final double value;
  final Color barColor;
  final Color rightFillColor;
  final Color leftFillColor;
  final double height;
  final double barWidth;
  final BorderRadius _cornerRadius;
  final TextStyle labelStyle;
  final void Function(double value)? onChange;

  @override
  State<AnimatedSlider> createState() => _AnimatedSliderState();
}

class _AnimatedSliderState extends State<AnimatedSlider> {
  static const Duration _animationDuration = Duration(milliseconds: 100);
  static const double _barHorizontalMargins = 6.0;
  static const double _labelsHorizontalMargins = 12.0;

  late final double _dragBarWidth;
  late final Size _dragRegion;

  late final ValueNotifier<double> _progressNotifier;
  late final ValueNotifier<bool> _overflowingNotifier;

  @override
  void initState() {
    super.initState();
    _dragBarWidth = widget.barWidth + (_barHorizontalMargins * 2);
    _dragRegion = Size(_dragBarWidth + 20, widget.height);
    _progressNotifier = ValueNotifier(widget.value);
    _overflowingNotifier = ValueNotifier(false);
  }

  void _onTextSizeChange(double textWidth, double leftBoxWidth, double rightBoxWidth) {
    double labelWidth = textWidth + _labelsHorizontalMargins;
    _overflowingNotifier.value = leftBoxWidth < labelWidth || rightBoxWidth < labelWidth;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails dragDetails, double sliderWidth) {
    double position = (dragDetails.globalPosition.dx - _dragBarWidth) / sliderWidth;
    _progressNotifier.value = position.clamp(0.0, 1.0);
    widget.onChange?.call(_progressNotifier.value);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double sliderWidth = constraints.maxWidth;
          double sliderHeight = constraints.maxHeight;
          double sliderWidthWithoutBar = sliderWidth - _dragBarWidth;

          return ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (context, progress, _) {
              double leftBoxWidth = sliderWidthWithoutBar * progress;
              double rightBoxWidth = sliderWidthWithoutBar - leftBoxWidth;
              int progressPercent = (progress * 100).toInt();

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        width: leftBoxWidth,
                        height: sliderHeight,
                        duration: _animationDuration,
                        decoration: BoxDecoration(
                          color: widget.leftFillColor,
                          borderRadius: widget._cornerRadius,
                        ),
                      ),
                      SliderBar(
                        color: widget.barColor,
                        width: widget.barWidth,
                        cornerRadius: widget._cornerRadius,
                      ),
                      AnimatedContainer(
                        width: rightBoxWidth,
                        height: sliderHeight,
                        duration: _animationDuration,
                        decoration: BoxDecoration(
                          color: widget.rightFillColor,
                          borderRadius: widget._cornerRadius,
                        ),
                      ),
                    ],
                  ),

                  SliderLabels(
                    progressPercent: progressPercent,
                    style: widget.labelStyle.copyWith(
                      color: widget.labelStyle.color?.withOpacity(
                        _overflowingNotifier.value ? 1.0 : 0.7,
                      ),
                    ),
                    onSizeChange: (width) =>
                        _onTextSizeChange(width, leftBoxWidth, rightBoxWidth),
                    isOverflowing: _overflowingNotifier,
                    height: sliderHeight,
                    width: sliderWidth,
                  ),

                  Positioned.fromRect(
                    rect: Rect.fromCenter(
                      width: _dragRegion.width,
                      height: _dragRegion.height,
                      center: Offset(leftBoxWidth + _dragBarWidth / 2, sliderHeight / 2),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (dragDetails) =>
                          _onHorizontalDragUpdate(dragDetails, sliderWidth),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
