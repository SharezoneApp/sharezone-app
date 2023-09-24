// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/widgets/check_tile.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';

class DataProtection extends StatelessWidget {
  const DataProtection({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const ValueKey('privacy'),
      child: ImageText(
        desktopSpacing: 32,
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline(
              "Sicher & DSGVO-konform",
            ),
            SizedBox(height: 24),
            ColumnSpacing(
              spacing: 12,
              children: [
                CheckTile(
                  title: "Standort der Server: Frankfurt (Deutschland)",
                  subtitle:
                      "Mit Ausnahme des Authentifizierungsserver\n(EU-Standardvertragsklauseln)",
                ),
                CheckTile(
                  title: "TLS-Verschlüsselung bei der Übertragung",
                ),
                CheckTile(
                  title: "AES 256-Bit serverseitige Verschlüsselung",
                ),
                CheckTile(
                  title: "ISO27001, ISO27012 & ISO27018 zertifiziert*",
                ),
                CheckTile(
                  title: "SOC1, SOC2, & SOC3 zertifiziert*",
                  subtitle: "* Zertifizierung von unserem Hosting-Anbieter",
                ),
              ],
            )
          ],
        ),
        image: Align(
          child: SvgPicture.asset(
            "assets/illustrations/gdpr.svg",
            height: 420,
          ),
        ),
        imagePosition: ImagePosition.right,
      ),
    );
  }
}
