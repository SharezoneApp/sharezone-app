import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SharezonePlusPageTheme extends StatelessWidget {
  const SharezonePlusPageTheme({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).isDarkTheme
                ? Colors.grey[400]
                : Colors.grey[600],
            fontSize: 16,
          ),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontSize: 18,
          ),
          headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      child: child,
    );
  }
}
