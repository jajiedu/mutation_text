import 'package:flutter/material.dart';
import 'package:mutation_text/extended_text/extended_text.dart';

///
///  create by zmtzawqlp on 2019/6/5
///

///builder of textSelectionPointerHandler,you can use this to custom your selection behavior
typedef TextSelectionPointerHandlerWidgetBuilder = Widget Function(
    List<ExtendedTextSelectionState> state);
