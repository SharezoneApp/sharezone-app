import 'package:flutter/material.dart';
import 'package:sharezone_website/widgets/check_tile.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/image_text.dart';
import 'package:sharezone_website/widgets/svg.dart';

class DataProtection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: ValueKey('privacy'),
      child: ImageText(
        desktopSpacing: 32,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Headline(
              "Sicher & DSGVO-konform",
            ),
            const SizedBox(height: 24),
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
          child: PlatformSvg.asset(
            "assets/illustrations/gdpr.svg",
            height: 420,
          ),
        ),
        imagePosition: ImagePosition.right,
      ),
    );
  }
}
