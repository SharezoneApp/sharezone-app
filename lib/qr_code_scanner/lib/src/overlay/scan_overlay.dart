import 'package:flutter/material.dart';

import 'scan_selection.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        ScanSelectionOverlay(),
      ],
    );
  }
}
