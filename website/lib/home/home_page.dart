import 'package:flutter/material.dart';
import "package:build_context/build_context.dart";

import '../page.dart';
import 'src/all_in_one_platform.dart';
import 'src/all_plattforms.dart';
import 'src/data_protection.dart';
import 'src/support.dart';
import 'src/traction.dart';
import 'src/usp.dart';
import 'src/welcome.dart';

const tabHeight = 57;
const maxWidthConstraint = 1200.0;

bool isTablet(BuildContext context) {
  return context.mediaQuerySize.width < 950;
}

bool isPhone(BuildContext context) {
  return context.mediaQuerySize.width < 650;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const tag = "home-page";

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      children: [
        Welcome(),
        Traction(),
        SizedBox(height: 100),
        AllInOnePlace(),
        SizedBox(height: 135),
        USP(),
        SizedBox(height: 135),
        DataProtection(),
        SizedBox(height: 135),
        Support(),
        SizedBox(height: 135),
        AllPlatforms(),
        SizedBox(height: 135),
      ],
    );
  }
}
