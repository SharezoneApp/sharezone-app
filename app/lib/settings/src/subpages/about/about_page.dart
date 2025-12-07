// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone/util/platform_information_manager/get_platform_information_retreiver.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'widgets/about_section.dart';
import 'widgets/social_media_button.dart';
import 'widgets/team.dart';

TextStyle _greyTextStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).isDarkTheme ? null : Colors.black54,
    fontWeight: FontWeight.normal,
    height: 1.05,
    fontSize: 16.0,
  );
}

class AboutPage extends StatelessWidget {
  static const String tag = "about-page";

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.aboutTitle), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _AboutHeader(),
                const SizedBox(height: 20),
                _AboutSharezone(),
                const SizedBox(height: 20),
                _FollowUs(),
                const SizedBox(height: 20),
                const TeamList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AvatarCard(
      svgPath: "assets/logo",
      crossAxisAlignment: CrossAxisAlignment.center,
      avatarBackgroundColor: Colors.white,
      children: <Widget>[
        Text(
          context.l10n.aboutHeaderTitle,
          style: TextStyle(
            color:
                Theme.of(context).isDarkTheme ? Colors.white : Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          context.l10n.aboutHeaderSubtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
        FutureBuilder<PlatformInformationRetriever>(
          future: getPlatformInformationRetrieverWithInit(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(context.l10n.aboutLoadingVersion);
            }
            if (snapshot.hasError) {
              return Text(context.l10n.commonDisplayError('${snapshot.error}'));
            }
            final buildNumber = snapshot.data?.versionNumber;
            final version = snapshot.data?.version;
            return Text(
              context.l10n.aboutVersion(version, buildNumber),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FollowUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutSection(
      title: context.l10n.aboutFollowUsTitle,
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Text(
              context.l10n.aboutFollowUsSubtitle,
              style: _greyTextStyle(context),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SocialButton.instagram(
                  context,
                  "https://sharezone.net/instagram",
                ),
                SocialButton.twitter(context, "https://sharezone.net/twitter"),
                SocialButton.discord(context, "https://sharezone.net/discord"),
                SocialButton.github(context, "https://sharezone.net/github"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSharezone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutSection(
      title: context.l10n.aboutSectionTitle,
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                context.l10n.aboutSectionDescription,
                style: _greyTextStyle(context),
              ),
              const SizedBox(height: 8),
              MarkdownBody(
                data: context.l10n.aboutSectionVisitWebsite,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context),
                ).copyWith(a: linkStyle(context), p: _greyTextStyle(context)),
                onTapLink: (url, _, _) => launchURL(url, context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
