import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  static String tag = 'subscription-page';
  const SubscriptionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Jetzt Sharezone Plus holen!'),
            ElevatedButton(
              child: Text('Abonnieren'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
