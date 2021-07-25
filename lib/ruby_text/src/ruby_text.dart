import 'package:flutter/widgets.dart';
import 'package:ruby_text/extended_text/extended_text.dart';

import '../../extended_text/extended_text_controls.dart';
import 'build_ruby_span.dart';
import 'ruby_text_data.dart';

class RubyText extends StatelessWidget {
  const RubyText(
    this.fullText,
    this.data, {
    this.style,
    this.rubyStyle,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onPanUpdate,
    this.onTapCancel,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.scrollController,
    this.focusNode,
    this.onTextChanged,
    this.disposeSelected,
    this.onTapChildText,
    Key? key,
  }) : super(key: key);
  final String? fullText;
  final List<RubyTextData>? data;
  final TextStyle? style;
  final TextStyle? rubyStyle;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTap;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureTapCancelCallback? onTapCancel;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final ScrollController? scrollController;
  final FocusNode? focusNode;
  final Function(String, double)? onTextChanged;
  final VoidCallback? disposeSelected;
  final Function(String)? onTapChildText;

  @override
  Widget build(BuildContext context) {
    data!.map(
      (data) => buildRubySpan(
        data.text,
        ruby: data.ruby,
        context: context,
        style: data.style,
        rubyStyle: data.rubyStyle,
        onTapDown: data.onTapDown,
        onTapUp: data.onTapUp,
        onTapChildText: onTapChildText,
        onTapCancel: data.onTapCancel,
        onPanUpdate: (details) {},
        onTap: () {},
      ),
    );
    return ExtendedText.rich(
      TextSpan(
        children: data!
            .map<InlineSpan>(
              (data) => buildRubySpan(
                data.text,
                ruby: data.ruby,
                context: context,
                style: data.style,
                rubyStyle: data.rubyStyle,
                onTapDown: data.onTapDown,
                onTapUp: data.onTapUp,
                onTapChildText: onTapChildText,
                onTapCancel: data.onTapCancel,
                onPanUpdate: (details) {},
                onTap: () {},
              ),
            )
            .toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      selectionEnabled: true,
      selectionControls: MyTextSelectionControls(
          fullText: fullText,
          listData: data,
          onTextChanged: onTextChanged,
          disposeSelected: disposeSelected),
    );
  }
}
