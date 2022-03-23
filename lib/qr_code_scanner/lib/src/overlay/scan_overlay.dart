import 'package:flutter/material.dart';

import 'scan_selection.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    Key? key,
    this.description,
  }) : super(key: key);

  final Widget? description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const ScanSelectionOverlay(),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 400, left: 32, right: 32),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                child: description!,
              ),
            ),
        ],
      ),
    );
  }
}
