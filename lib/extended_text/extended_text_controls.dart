import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../ruby_text/ruby_text.dart';

///
///  create by zmtzawqlp on 2019/8/3
///
const double _kHandleSize = 22;

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 8;

/// Android Material styled text selection controls.
class MyTextSelectionControls extends TextSelectionControls {
  MyTextSelectionControls(
      {this.joinZeroWidthSpace = false,
      this.fullText,
      this.listData,
      this.onTextChanged,
      this.disposeSelected});
  final bool? joinZeroWidthSpace;
  final String? fullText;
  final List<RubyTextData>? listData;

  Function(String, double)? onTextChanged;
  final VoidCallback? disposeSelected;

  @override
  void handleCopy(TextSelectionDelegate delegate,
      ClipboardStatusNotifier? clipboardStatus) {
    final TextEditingValue value = delegate.textEditingValue;
    Clipboard.setData(ClipboardData(
      text: value.selection.textInside(value.text),
    ));
    clipboardStatus?.update();
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        // Hide the toolbar, but keep the selection and keep the handles.
        delegate.hideToolbar(false);
        return;
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // Collapse the selection and hide the toolbar and handles.
        delegate.userUpdateTextEditingValue(
          TextEditingValue(
            text: value.text,
            selection: TextSelection.collapsed(offset: value.selection.end),
          ),
          SelectionChangedCause.toolBar,
        );
        delegate.hideToolbar();
        return;
    }
  }

  /// Returns the size of the Material handle.
  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_kHandleSize, _kHandleSize);

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    // lấy đoạn văn bản đã chọn
    final getSelectedText = getSelectText(
        delegate.textEditingValue.selection.start,
        delegate.textEditingValue.selection.end,
        fullText!,
        listData!);
    final endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];

    ///endTextSelectionPoint.point.dy: tọa độ y của điểm leo dưới
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onTextChanged!(getSelectedText, endTextSelectionPoint.point.dy);
    });

    return Container(
      width: 0,
      height: 0,
    );
    // _TextSelectionControlsToolbar(
    //     globalEditableRegion: globalEditableRegion,
    //     textLineHeight: textLineHeight,
    //     selectionMidpoint: selectionMidpoint,
    //     endpoints: endpoints,
    //     delegate: delegate,
    //     clipboardStatus: clipboardStatus,
    //     handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
    //     handleCopy: canCopy(delegate)
    //         ? () => handleCopy(delegate, clipboardStatus)
    //         : null,
    //     handlePaste:
    //         canPaste(delegate) ? () => handlePaste(delegate) : null,
    //     handleSelectAll:
    //         canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
    //     handleLike: () {
    //       delegate.hideToolbar();

    //       delegate.userUpdateTextEditingValue(
    //           delegate.textEditingValue.copyWith(
    //               selection: const TextSelection.collapsed(offset: 0)),
    //           SelectionChangedCause.toolBar);
    //     },
    //     disposeSelected: disposeSelected);
  }

  String getSelectText(
      int start, int end, String fullText, List<RubyTextData> listData) {
    var startPosition = 0;
    var lengthOfText = 0;
    String selectedText;
    for (var i = 0; i < start; i++) {
      startPosition = startPosition + listData[i].getLength();
    }
    for (var i = start; i < end; i++) {
      lengthOfText = lengthOfText + listData[i].getLength();
    }
    try {
      selectedText =
          fullText.substring(startPosition, startPosition + lengthOfText);
    } catch (e) {
      return 'error';
    }
    return selectedText;
  }

  /// Builder for material-style text selection handles.
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type,
      double textLineHeight) {
    final theme = Theme.of(context);
    final handleColor = TextSelectionTheme.of(context).selectionHandleColor ??
        theme.colorScheme.primary;

    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: CustomPaint(
        painter: _TextSelectionHandlePainter(
          color: handleColor,
        ),
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(
          angle: math.pi / 2.0,
          child: handle,
        );
      case TextSelectionHandleType.right: // points up-left
        return handle;
      case TextSelectionHandleType.collapsed: // points up
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
    }
    // return super.buildHandle(context, type, textLineHeight, onTap);
  }

  /// Gets anchor for material-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kHandleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      default:
        return const Offset(_kHandleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Android allows SelectAll when selection is not collapsed, unless
    // everything has already been selected.
    final value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 &&
            value.selection.end == value.text.length);
  }
}

/// Draws a single text selection handle which points up and to the left.
class _TextSelectionHandlePainter extends CustomPainter {
  _TextSelectionHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final radius = size.width / 2.0;
    final circle =
        Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    final point = Rect.fromLTWH(0, 0, radius, radius);
    final path = Path()
      ..addOval(circle)
      ..addRect(point);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) {
    return color != oldPainter.color;
  }
}

// The label and callback for the available default text selection menu buttons.
class _TextSelectionToolbarItemData {
  const _TextSelectionToolbarItemData(
      {required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}

// The highest level toolbar widget, built directly by buildToolbar.
class _TextSelectionControlsToolbar extends StatefulWidget {
  const _TextSelectionControlsToolbar({
    required Key key,
    required this.clipboardStatus,
    required this.delegate,
    required this.endpoints,
    required this.globalEditableRegion,
    required this.handleCut,
    required this.handleCopy,
    required this.handlePaste,
    required this.handleSelectAll,
    required this.selectionMidpoint,
    required this.textLineHeight,
    required this.handleLike,
    required this.disposeSelected,
  }) : super(key: key);

  final ClipboardStatusNotifier clipboardStatus;
  final TextSelectionDelegate delegate;
  final List<TextSelectionPoint> endpoints;
  final Rect globalEditableRegion;
  final VoidCallback handleCut;
  final VoidCallback handleCopy;
  final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;
  final VoidCallback handleLike;
  final Offset selectionMidpoint;
  final double textLineHeight;
  final VoidCallback disposeSelected;

  @override
  _TextSelectionControlsToolbarState createState() =>
      _TextSelectionControlsToolbarState();
}

class _TextSelectionControlsToolbarState
    extends State<_TextSelectionControlsToolbar> with TickerProviderStateMixin {
  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  @override
  void didUpdateWidget(_TextSelectionControlsToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    super.dispose();
    // When used in an Overlay, it can happen that this is disposed after its
    // creator has already disposed _clipboardStatus.
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // onTextChanged(getSelectedText);
        widget.disposeSelected();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If there are no buttons to be shown, don't render anything.
    if (widget.handleCut == null &&
        widget.handleCopy == null &&
        widget.handlePaste == null &&
        widget.handleSelectAll == null) {
      return const SizedBox.shrink();
    }
    // If the paste button is desired, don't render anything until the state of
    // the clipboard is known, since it's used to determine if paste is shown.
    if (widget.handlePaste != null &&
        widget.clipboardStatus.value == ClipboardStatus.unknown) {
      return const SizedBox.shrink();
    }

    // Calculate the positioning of the menu. It is placed above the selection
    // if there is enough room, or otherwise below.
    final startTextSelectionPoint = widget.endpoints[0];
    final endTextSelectionPoint =
        widget.endpoints.length > 1 ? widget.endpoints[1] : widget.endpoints[0];
    final anchorAbove = Offset(
        widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
        widget.globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            widget.textLineHeight -
            _kToolbarContentDistance);
    final anchorBelow = Offset(
      widget.globalEditableRegion.left + widget.selectionMidpoint.dx,
      widget.globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );
    // print(endTextSelectionPoint.point.dy);

    // Determine which buttons will appear so that the order and total number is
    // known. A button's position in the menu can slightly affect its
    // appearance.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final List<_TextSelectionToolbarItemData> itemDatas =
        <_TextSelectionToolbarItemData>[
      if (widget.handleCut != null)
        _TextSelectionToolbarItemData(
          label: localizations.cutButtonLabel,
          onPressed: widget.handleCut,
        ),
      if (widget.handleCopy != null)
        _TextSelectionToolbarItemData(
          label: localizations.copyButtonLabel,
          onPressed: widget.handleCopy,
        ),
      if (widget.handlePaste != null &&
          widget.clipboardStatus.value == ClipboardStatus.pasteable)
        _TextSelectionToolbarItemData(
          label: localizations.pasteButtonLabel,
          onPressed: widget.handlePaste,
        ),
      if (widget.handleSelectAll != null)
        _TextSelectionToolbarItemData(
          label: localizations.selectAllButtonLabel,
          onPressed: widget.handleSelectAll,
        ),
      _TextSelectionToolbarItemData(
        label: 'like',
        onPressed: widget.handleLike,
      ),
    ];

    // If there is no option available, build an empty widget.
    if (itemDatas.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }
    return Container();
  }
}
