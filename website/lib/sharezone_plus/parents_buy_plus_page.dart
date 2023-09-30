import 'package:flutter/material.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/section.dart';

class ParentsBuyPlusPage extends StatelessWidget {
  const ParentsBuyPlusPage({
    super.key,
    required this.studentId,
  });

  final String studentId;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        Align(
          child: Section(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    child: Headline(
                      "Sharezone Plus",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('StudentId: $studentId'),
                  const SizedBox(height: 12),
                  const _BuyButton()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Jetzt Sharezone Plus kaufen!'),
    );
  }
}
