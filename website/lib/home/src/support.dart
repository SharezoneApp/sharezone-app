// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/section_action_button.dart';
import 'package:sharezone_website/widgets/subline.dart';

import '../../support_page.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const ValueKey('support'),
      child: ImageText(
        desktopSpacing: 100,
        imagePosition: ImagePosition.left,
        image:
            SvgPicture.asset("assets/illustrations/support.svg", height: 400),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headline(
              "Nie im Stich gelassen.",
            ),
            const SizedBox(height: 20),
            const Subline(
              "Unser Support ist für Dich jederzeit erreichbar. Egal welche Uhrzeit. Egal welcher Wochentag.",
            ),
            const SizedBox(height: 20),
            SectionActionButton(
              text: "Support kontaktieren",
              onTap: () => context.go('/$SupportPage.tag'),
            ),
          ],
        ),
      ),
    );
  }
}
