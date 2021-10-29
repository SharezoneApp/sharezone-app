import 'package:flutter/material.dart';
import 'package:sharezone_website/home/home_page.dart';

import 'max_width_constraint_box.dart';

class Section extends StatelessWidget {
  const Section({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: maxWidthConstraint,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPhone(context) ? 20 : 64),
        child: child,
      ),
    );
  }
}