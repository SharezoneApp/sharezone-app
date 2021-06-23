import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/section_action_button.dart';
import 'package:sharezone_website/widgets/subline.dart';
import 'package:sharezone_website/widgets/svg.dart';

class USP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageText(
      desktopSpacing: 64,
      body: _UspText(),
      image: _UspImage(),
      imagePosition: ImagePosition.left,
    );
  }
}

class _UspImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformSvg.asset(
      "assets/illustrations/usp.svg",
      width: 400,
    );
  }
}

class _UspText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('usp'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Headline("Wirklich hilfreich."),
          Subline(
            "Sharezone ist aus den realen Problemen des Unterrichts entstanden.",
          ),
          const SizedBox(height: 10),
          Subline(
            "Wir wissen, was für Lösungen nötig sind und was wirklich hilft, um den Schulalltag einfach zu machen.\nWo wir es nicht wissen, versuchen wir, mit agiler Arbeit und der Sharezone-Community die beste Lösung zu finden.",
          ),
          const SizedBox(height: 25),
          SectionActionButton.openLink(
            text: "Zur Sharezone-Community",
            link: "https://sharezone.net/discord",
          ),
        ],
      ),
    );
  }
}