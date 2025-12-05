// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/widgets/column_spacing.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/row_spacing.dart';
import 'package:sharezone_website/widgets/section.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart' hide Headline;

import '../home_page.dart';

class AllInOnePlace extends StatefulWidget {
  const AllInOnePlace({super.key});

  @override
  AllInOnePlaceState createState() => AllInOnePlaceState();
}

class AllInOnePlaceState extends State<AllInOnePlace> {
  String currentFeature = defaultFeature;
  static const defaultFeature = "uebersicht";

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const ValueKey('all-in-one-place'),
      child: Section(
        child: Column(
          children: [
            const Headline("Alles an einem Ort"),
            const SizedBox(height: 12),
            RowSpacing(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: isTablet(context) ? 10 : 32,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ColumnSpacing(
                      spacing: 10,
                      children: [
                        feature(
                          "Aufgaben",
                          bulletpoints: [
                            "Mit Erinnerungsfunktion",
                            "Mit Kommentarfunktion",
                            "Mit Abgabefunktion",
                          ],
                        ),
                        feature(
                          "Infozettel",
                          bulletpoints: [
                            "Mit Lesebestätigung",
                            "Mit Kommentarfunktion",
                            "Mit Notifications",
                          ],
                        ),
                        feature(
                          "Dateiablage",
                          bulletpoints: [
                            "Arbeitsmaterialien teilen",
                            "Optional: Unbegrenzter \nSpeicherplatz",
                          ],
                        ),
                        feature(
                          "Termine",
                          bulletpoints: [
                            "Prüfungen und Termine auf einen Blick",
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isTablet(context))
                  AnimatedSwitcher(
                    // Adding the default transitionBuilder here fixes
                    // https://github.com/flutter/flutter/issues/121336. The bug can occur
                    // when clicking the card very quickly.
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      key: ValueKey(currentFeature),
                      width: 350,
                      child: Image.asset(
                        "assets/features/${currentFeature.toLowerCase()}.png",
                        height: 650,
                        semanticLabel: currentFeature,
                      ),
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ColumnSpacing(
                      spacing: 10,
                      children: [
                        feature(
                          "Notensystem",
                          bulletpoints: [
                            "Speichere deine Noten in Sharezone",
                            "Verschiedene Notensysteme",
                          ],
                          height: 60,
                        ),
                        feature(
                          "Immer verfügbar",
                          bulletpoints: [
                            "Offline Inhalte eintragen",
                            "Mit mehreren Geräten nutzbar",
                          ],
                          leaveDefaultPicture: true,
                          height: 60,
                        ),
                        feature(
                          "Stundenplan",
                          bulletpoints: [
                            "Mit A/B Wochen",
                            "Wochentage individuell einstellbar",
                          ],
                        ),
                        feature(
                          "Notifications",
                          bulletpoints: [
                            "Mit Ruhemodus",
                            "Immer informiert",
                            "Individuell einstellbar",
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget feature(
    String title, {
    List<String> bulletpoints = const [],
    String? subtitle,
    double? height,

    /// Don't change phone mockup picture if true
    bool leaveDefaultPicture = false,
  }) {
    return MouseRegion(
      onHover:
          (event) =>
          // If we don't call setState when [leaveDefaultPicture] is `true`
          // then the text in the [_FeatureCard] won't be drawn somehow.
          setState(() => leaveDefaultPicture ? (_) {} : currentFeature = title),
      onExit: (event) => setState(() => currentFeature = defaultFeature),
      child: _FeatureCard(
        title: title,
        subtitle: subtitle,
        bulletpoints: bulletpoints,
        height: height,
        onTap: (title) {
          setState(() {
            if (!leaveDefaultPicture) {
              currentFeature = title;
            }
          });
        },
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.title,
    this.subtitle,
    this.onTap,
    this.bulletpoints = const [],
    this.height,
  });

  final String title;
  final String? subtitle;
  final List<String> bulletpoints;
  final ValueChanged<String>? onTap;
  final double? height;

  @override
  __FeatureCardState createState() => __FeatureCardState();
}

class __FeatureCardState extends State<_FeatureCard> {
  // Please use 0.0 instead of 0. You will get a .toDouble() issue, if you
  // use 0 instead of 0.0
  final nonHoverTransform =
      Matrix4.identity()..translateByDouble(0.0, 0.0, 0.0, 1.0);
  final hoverTransform =
      Matrix4.identity()..translateByDouble(10.0, 0.0, 0.0, 1.0);

  bool showIcon = true;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => showIcon = false,
      onExit: (event) => showIcon = true,
      child: CustomCard(
        onTap: isTablet(context) ? null : () => widget.onTap!(widget.title),
        child: SizedBox(
          height: 115,
          width: isTablet(context) ? double.infinity : 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    showIcon
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Semantics(
                            image: true,
                            label: 'An image of the ${widget.title} feature',
                            child: SvgPicture.asset(
                              "assets/icons/${widget.title.toLowerCase()}.svg",
                              height: widget.height ?? 45,
                            ),
                          ),
                        )
                        : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SizedBox(
                              height: 52,
                              child: DefaultTextStyle(
                                style: TextStyle(color: Colors.grey[600]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final subtitle in widget.bulletpoints)
                                      Text("• $subtitle"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
