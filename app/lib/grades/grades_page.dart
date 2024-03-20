import 'package:flutter/material.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  static const tag = "grades-page";

  @override
  Widget build(BuildContext context) {
    return SharezoneMainScaffold(
      navigationItem: NavigationItem.grades,
      body: Text('Grades'),
    );
  }
}
