import 'package:flutter/foundation.dart';

class Action {
  final String title;
  final VoidCallback onTap;

  const Action({
    @required this.title,
    @required this.onTap,
  });
}
