import 'package:flutter/material.dart';

class LongPress<T> {
  final String title;
  final T popResult;
  final Widget icon;

  const LongPress({
    @required this.title,
    @required this.popResult,
    this.icon,
  });
}
