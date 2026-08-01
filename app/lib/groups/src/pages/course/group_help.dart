// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

TextStyle _descriptionStyle(BuildContext context) => TextStyle(
  color: context.isDarkThemeEnabled ? Colors.grey[300] : Colors.grey[700],
  fontSize: 16,
);

class CourseHelpPage extends StatelessWidget {
  static const String tag = "course-help-page";

  const CourseHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.groupHelpTitle),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(child: CourseHelpInnerPage()),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}

class CourseHelpInnerPage extends StatelessWidget {
  const CourseHelpInnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: <Widget>[
          _WhatIsASharecode(),
          SizedBox(height: 8),
          _HowToJoinAGroup(),
          SizedBox(height: 8),
          _WhyHasEveryMemberOfAGroupADifferentSharecode(),
          SizedBox(height: 8),
          _WhatIsTheDifferenceBetweenAGroupACourseAndASchoolClass(),
          SizedBox(height: 8),
          _GroupRolesExplained(),
        ],
      ),
    );
  }
}

class _WhatIsASharecode extends StatelessWidget {
  const _WhatIsASharecode();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.groupHelpWhatIsSharecodeTitle),
      body: Text(
        context.l10n.groupHelpWhatIsSharecodeDescription,
        style: _descriptionStyle(context),
      ),
    );
  }
}

class _HowToJoinAGroup extends StatefulWidget {
  const _HowToJoinAGroup();

  @override
  _HowToJoinAGroupState createState() => _HowToJoinAGroupState();
}

class _HowToJoinAGroupState extends State<_HowToJoinAGroup> {
  Color? _svgColor = Colors.grey[600];
  Color? _typeInPublicKeyIconColor = Colors.grey[600];

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.groupHelpHowToJoinTitle),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.groupHelpHowToJoinOverview,
            style: _descriptionStyle(context),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            title: ExpansionTileTitle(
              title: context.l10n.groupHelpScanQrCodeTitle,
              icon: Padding(
                padding: const EdgeInsets.only(left: 2),
                child: SvgPicture.asset(
                  "assets/icons/qr-code.svg",
                  colorFilter: ColorFilter.mode(_svgColor!, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            onExpansionChanged: (value) {
              if (value) {
                setState(() {
                  // Expansion is open: so let's make the svg black
                  _svgColor =
                      Theme.of(context).isDarkTheme
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary;
                });
              } else {
                // Expansion is closed: so let's make the svg grey
                setState(() {
                  _svgColor = Colors.grey[600];
                });
              }
            },
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).add(const EdgeInsets.only(bottom: 16)),
                child: Column(
                  children: <Widget>[
                    Text(
                      context.l10n.groupHelpScanQrCodeDescription,
                      style: _descriptionStyle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: ExpansionTileTitle(
              title: context.l10n.groupHelpTypeSharecodeTitle,
              icon: Icon(Icons.keyboard, color: _typeInPublicKeyIconColor),
            ),
            onExpansionChanged: (value) {
              if (value) {
                setState(() {
                  // Expansion is open: so let's make the svg black
                  _typeInPublicKeyIconColor =
                      Theme.of(context).isDarkTheme
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary;
                });
              } else {
                // Expansion is closed: so let's make the svg grey
                setState(() {
                  _typeInPublicKeyIconColor = Colors.grey[600];
                });
              }
            },
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).add(const EdgeInsets.only(bottom: 16)),
                child: Text(
                  context.l10n.groupHelpTypeSharecodeDescription,
                  style: _descriptionStyle(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhyHasEveryMemberOfAGroupADifferentSharecode extends StatelessWidget {
  const _WhyHasEveryMemberOfAGroupADifferentSharecode();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.groupHelpWhyDifferentSharecodesTitle),
      body: Text(
        context.l10n.groupHelpWhyDifferentSharecodesDescription,
        style: _descriptionStyle(context),
      ),
    );
  }
}

class _WhatIsTheDifferenceBetweenAGroupACourseAndASchoolClass
    extends StatelessWidget {
  const _WhatIsTheDifferenceBetweenAGroupACourseAndASchoolClass();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.groupHelpDifferenceTitle),
      body: Text(
        context.l10n.groupHelpDifferenceDescription,
        style: _descriptionStyle(context),
      ),
    );
  }
}

class _GroupRolesExplained extends StatelessWidget {
  const _GroupRolesExplained();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.groupHelpRolesTitle),
      body: Text(
        context.l10n.groupHelpRolesDescription,
        style: _descriptionStyle(context),
      ),
    );
  }
}
