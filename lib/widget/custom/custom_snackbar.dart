import 'package:fgsdm/widget/responsive/responsive_icon.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static final CustomSnackBar _instance = CustomSnackBar._internal();
  BuildContext? _context;

  CustomSnackBar._internal();

  factory CustomSnackBar() {
    return _instance;
  }

  static CustomSnackBar of(BuildContext context) {
    _instance._context = context;
    return _instance;
  }

  void show({
    String message = "Success",
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    bool showCloseIcon = true,
    IconData? prefixIcon,
    bool onTop = false,
    Duration? duration = const Duration(seconds: 3)
  }) {
    if (_context == null) {
      throw Exception("Context is not set");
    }

    var snackBarContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (prefixIcon != null) Container(
                    width: 42,
                    height: 42,
                    child: ResponsiveIcon(prefixIcon, color: Colors.white,),
                    margin: EdgeInsets.only(right: 16),
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 42
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            message,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onTop && showCloseIcon) InkWell(
              onTap: () {

              },
              child: Container(
                width: 42,
                height: 42,
                child: ResponsiveIcon(Icons.close, color: Colors.white,),
              ),
            ),
            if (!onTop) SizedBox(height: 42,)
          ],
        )
      ],
    );

    if (!onTop) _showSnackBar(snackBarContent, backgroundColor, showCloseIcon, duration ?? Duration(seconds: 3));
    else _showTopSnackBar(snackBarContent, backgroundColor, duration ?? Duration(seconds: 3));
  }

  _showSnackBar(Widget content, Color backgroundColor, bool showCloseIcon, Duration duration) {
    var snackBar = SnackBar(
      duration: duration,
      backgroundColor: backgroundColor,
      content: content,
      showCloseIcon: showCloseIcon,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(_context!).showSnackBar(snackBar);
  }

  _showTopSnackBar(Widget content, Color backgroundColor, Duration duration) {
    final overlay = Overlay.of(_context!);
    final _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60.0,
        left: 20,
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: content,
          ),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      overlay.insert(_overlayEntry);
    });

    Future.delayed(duration, () {
      _overlayEntry.remove();
    });
  }

  void hide() {
    if (_context != null) {
      Navigator.of(_context!, rootNavigator: true).pop();
    }
  }
}
