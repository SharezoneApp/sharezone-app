import 'package:flutter/material.dart';
import 'package:sharezone_widgets/widgets.dart';

class StateSheetLoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        SizedBox(
          width: 35,
          height: 35,
          child: const AccentColorCircularProgressIndicator(),
        ),
        const SizedBox(height: 16),
        Text(
          "Daten werden verschlüsselt übertragen...",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
