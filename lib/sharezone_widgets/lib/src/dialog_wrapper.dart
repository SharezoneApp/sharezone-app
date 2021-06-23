import 'package:flutter/material.dart';

class DialogWrapper extends StatelessWidget {
  const DialogWrapper({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 450),
      child: child,
    );
  }
}
