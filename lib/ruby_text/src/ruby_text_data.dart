import 'package:flutter/widgets.dart';

class RubyTextData {
  RubyTextData(
    this.text, {
    this.ruby,
    // this.style,
    // this.rubyStyle,
    // this.onTapDown,
    // this.onTapUp,
    // this.onTap,
    // this.onPanUpdate,
    // this.onTapCancel,
  });
  String? text = '';
  String? ruby = '';
  bool? isUnderlined;
  // TextStyle? style;
  // TextStyle? rubyStyle;
  // GestureTapDownCallback? onTapDown;
  // GestureTapUpCallback? onTapUp;
  // GestureTapCallback? onTap;
  // GestureDragUpdateCallback? onPanUpdate;
  // GestureTapCancelCallback? onTapCancel;

  int getLength() {
    return text!.length;
  }
}
