import 'package:flutter/material.dart';
import 'package:sharezone_widgets/widgets.dart';

class StateDialogLoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 16),
        AccentColorCircularProgressIndicator(),
        SizedBox(height: 16),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
