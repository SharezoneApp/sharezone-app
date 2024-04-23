import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_website/page.dart';

class PlusSuccessPage extends StatelessWidget {
  const PlusSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        SizedBox(height: 200),
        const Center(
          child:
              Text('Danke für deinen Einkauf!', style: TextStyle(fontSize: 40)),
        ),
      ],
    );
  }
}
