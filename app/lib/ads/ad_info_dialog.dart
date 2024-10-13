import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void showAdInfoDialog(BuildContext context) async {
  final navigateToPlusPage = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Werbung in Sharezone'),
        content: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text:
                    'Wir führen ein Experiment mit Werbung in Sharezone durch. Wenn du keine Werbung sehen möchten, kannst du ',
              ),
              TextSpan(
                text: 'Sharezone Plus',
                style: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).pop(true),
              ),
              const TextSpan(
                text: ' erwerben.',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );

  if (navigateToPlusPage == true && context.mounted) {
    navigateToSharezonePlusPage(context);
  }
}
