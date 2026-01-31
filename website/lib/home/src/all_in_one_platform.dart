// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
    final l10n = context.l10n;
    final leftFeatures = [
      FeatureData(
        id: "aufgaben",
        title: l10n.websiteFeatureTasksTitle,
        bulletpoints: [
          l10n.websiteFeatureTasksBulletpointReminder,
          l10n.websiteFeatureTasksBulletpointComments,
          l10n.websiteFeatureTasksBulletpointSubmissions,
        ],
      ),
      FeatureData(
        id: "infozettel",
        title: l10n.websiteFeatureNoticesTitle,
        bulletpoints: [
          l10n.websiteFeatureNoticesBulletpointReadReceipt,
          l10n.websiteFeatureNoticesBulletpointComments,
          l10n.websiteFeatureNoticesBulletpointNotifications,
        ],
      ),
      FeatureData(
        id: "dateiablage",
        title: l10n.websiteFeatureFileStorageTitle,
        bulletpoints: [
          l10n.websiteFeatureFileStorageBulletpointShareMaterials,
          l10n.websiteFeatureFileStorageBulletpointUnlimitedStorage,
        ],
      ),
      FeatureData(
        id: "termine",
        title: l10n.websiteFeatureEventsTitle,
        bulletpoints: [l10n.websiteFeatureEventsBulletpointAtAGlance],
      ),
    ];
    final rightFeatures = [
      FeatureData(
        id: "notensystem",
        title: l10n.websiteFeatureGradesTitle,
        bulletpoints: [
          l10n.websiteFeatureGradesBulletpointSaveGrades,
          l10n.websiteFeatureGradesBulletpointMultipleSystems,
        ],
        height: 60,
      ),
      FeatureData(
        id: "immer verfügbar",
        title: l10n.websiteFeatureAlwaysAvailableTitle,
        bulletpoints: [
          l10n.websiteFeatureAlwaysAvailableBulletpointOffline,
          l10n.websiteFeatureAlwaysAvailableBulletpointMultiDevice,
        ],
        leaveDefaultPicture: true,
        height: 60,
      ),
      FeatureData(
        id: "stundenplan",
        title: l10n.websiteFeatureTimetableTitle,
        bulletpoints: [
          l10n.websiteFeatureTimetableBulletpointAbWeeks,
          l10n.websiteFeatureTimetableBulletpointWeekdays,
        ],
      ),
      FeatureData(
        id: "notifications",
        title: l10n.websiteFeatureNotificationsTitle,
        bulletpoints: [
          l10n.websiteFeatureNotificationsBulletpointQuietHours,
          l10n.websiteFeatureNotificationsBulletpointAlwaysInformed,
          l10n.websiteFeatureNotificationsBulletpointCustomizable,
        ],
      ),
    ];
    final featureTitlesById = <String, String>{
      defaultFeature: l10n.websiteFeatureOverviewTitle,
      for (final feature in [...leftFeatures, ...rightFeatures])
        feature.id: feature.title,
    };
    final currentFeatureTitle =
        featureTitlesById[currentFeature] ?? currentFeature;
    return RepaintBoundary(
      key: const ValueKey('all-in-one-place'),
      child: Section(
        child: Column(
          children: [
            Headline(l10n.websiteAllInOneHeadline),
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
                        for (final featureData in leftFeatures)
                          feature(featureData),
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
                        "assets/features/$currentFeature.png",
                        height: 650,
                        semanticLabel: l10n.websiteAllInOneFeatureImageLabel(
                          currentFeatureTitle,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ColumnSpacing(
                      spacing: 10,
                      children: [
                        for (final featureData in rightFeatures)
                          feature(featureData),
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

  Widget feature(FeatureData featureData) {
    return MouseRegion(
      onHover:
          (event) =>
          // If we don't call setState when [leaveDefaultPicture] is `true`
          // then the text in the [_FeatureCard] won't be drawn somehow.
          setState(
            () =>
                featureData.leaveDefaultPicture
                    ? (_) {}
                    : currentFeature = featureData.id,
          ),
      onExit: (event) => setState(() => currentFeature = defaultFeature),
      child: _FeatureCard(
        title: featureData.title,
        iconAssetName: featureData.id,
        iconSemanticLabel: context.l10n.websiteAllInOneFeatureImageLabel(
          featureData.title,
        ),
        bulletpoints: featureData.bulletpoints,
        height: featureData.height,
        onTap: (title) {
          setState(() {
            if (!featureData.leaveDefaultPicture) {
              currentFeature = featureData.id;
            }
          });
        },
      ),
    );
  }
}

class FeatureData {
  const FeatureData({
    required this.id,
    required this.title,
    this.bulletpoints = const [],
    this.height,
    this.leaveDefaultPicture = false,
  });

  final String id;
  final String title;
  final List<String> bulletpoints;
  final double? height;
  final bool leaveDefaultPicture;
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.title,
    required this.iconAssetName,
    required this.iconSemanticLabel,
    this.onTap,
    this.bulletpoints = const [],
    this.height,
  });

  final String title;
  final String iconAssetName;
  final String iconSemanticLabel;
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
                            label: widget.iconSemanticLabel,
                            child: SvgPicture.asset(
                              "assets/icons/${widget.iconAssetName}.svg",
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
