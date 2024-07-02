import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static final LoadingDialog _instance = LoadingDialog._internal();
  BuildContext? _context;

  LoadingDialog._internal();

  factory LoadingDialog() {
    return _instance;
  }

  static LoadingDialog of(BuildContext context) {
    _instance._context = context;
    return _instance;
  }

  void show({String message = "Loading...",  isDismissible = false}) {
    if (_context == null) {
      throw Exception("Context is not set");
    }

    showDialog(
      context: _context!,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16,),
                ResponsiveText(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void hide() {
    if (_context != null) {
      Navigator.of(_context!, rootNavigator: true).pop();
    }
  }
}
