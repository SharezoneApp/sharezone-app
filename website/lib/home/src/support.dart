import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/section_action_button.dart';
import 'package:sharezone_website/widgets/subline.dart';

import '../../support_page.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('support'),
      child: ImageText(
        desktopSpacing: 100,
        imagePosition: ImagePosition.left,
        image:
            SvgPicture.asset("assets/illustrations/support.svg", height: 400),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline(
              "Nie im Stich gelassen.",
            ),
            const SizedBox(height: 20),
            Subline(
              "Unser Support ist für Dich jederzeit erreichbar. Egal welche Uhrzeit. Egal welcher Wochentag.",
            ),
            const SizedBox(height: 20),
            SectionActionButton(
              text: "Support kontaktieren",
              onTap: () => Navigator.pushNamed(context, SupportPage.tag),
            ),
          ],
        ),
      ),
    );
  }
}
