import 'package:flutter/material.dart';

void showSnackSec({
  required BuildContext context,
  String? text,
  int seconds = 3,
  bool withLoadingCircle = false,
  SnackBarAction? action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior? behavior,
}) {
  showSnack(
    context: context,
    duration: Duration(seconds: seconds),
    text: text,
    withLoadingCircle: withLoadingCircle,
    action: action,
    hideCurrentSnackBar: hideCurrentSnackBar,
    behavior: behavior,
  );
}

void showSnack({
  required BuildContext context,
  String? text,
  Duration duration = const Duration(seconds: 3),
  bool withLoadingCircle = false,
  SnackBarAction? action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior? behavior = SnackBarBehavior.floating,
}) {
  final snackBar = SnackBar(
    content: withLoadingCircle == false
        ? Text(text!)
        : Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 20, left: 4),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
                Flexible(child: Text(text!)),
              ],
            ),
          ),
    duration: duration,
    action: action,
    behavior: behavior,
  );

  try {
    if (hideCurrentSnackBar)
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } catch (e) {
    print(
        "Fehler beim anzeigen der SnackBar über den Kontext: ${e.toString()}");
  }
}
