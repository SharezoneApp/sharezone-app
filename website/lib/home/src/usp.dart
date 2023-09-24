// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/section_action_button.dart';
import 'package:sharezone_website/widgets/subline.dart';

class USP extends StatelessWidget {
  const USP({super.key});

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
    return SvgPicture.asset(
      "assets/illustrations/usp.svg",
      width: 400,
    );
  }
}

class _UspText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const ValueKey('usp'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Headline("Wirklich hilfreich."),
          const Subline(
            "Sharezone ist aus den realen Problemen des Unterrichts entstanden.",
          ),
          const SizedBox(height: 10),
          const Subline(
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
