import 'package:flutter/material.dart';

class Choice {
  final int index;
  final String text;
  final IconData icon;

  Choice({@required this.index, @required this.text, @required this.icon});
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = "Bitte bestätigen",
  String action = "Bestätigen",
  Widget text,
}) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: <Widget>[
              text ?? Container(),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Abbrechen".toUpperCase()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(action.toUpperCase()),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
          ],
        );
      });
}
