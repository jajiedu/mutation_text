import 'package:flutter/widgets.dart';

class RubyTextData {
  RubyTextData(
    this.text, {
    this.ruby,
    this.style,
    this.rubyStyle,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onPanUpdate,
    this.onTapCancel,
  });
  final String? text;
  final String? ruby;
  final TextStyle? style;
  final TextStyle? rubyStyle;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureTapCancelCallback? onTapCancel;

  int getLength() {
    return text!.length;
  }
}
