import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/translate_on_hover.dart';

extension HoverExtensions on Widget {
  Widget get moveLeftOnHover {
    return MoveLeftOnHover(child: this);
  }
}
