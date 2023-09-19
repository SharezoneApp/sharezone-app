// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/util/launch_link.dart';
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
      appBar: AppBar(title: const Text("Über uns"), centerTitle: true),
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

class _AboutHeader extends StatefulWidget {
  @override
  State<_AboutHeader> createState() => _AboutHeaderState();
}

class _AboutHeaderState extends State<_AboutHeader> {
  final tapNotifier = ValueNotifier<int>(0);

  void _handleSharezoneLogoTap() {
    switch (tapNotifier.value) {
      case 0:
        tapNotifier.value++;
        showSimpleNotification(
          const Text("Bald passiert etwas... Was ist nur los mit Sharezone???"),
          autoDismiss: true,
          slideDismissDirection: DismissDirection.horizontal,
          leading: const Icon(Icons.exposure_zero),
        );
        break;
      case 1:
        tapNotifier.value++;
        showSimpleNotification(
          const Text("Sharezone wächst, halte durch"),
          autoDismiss: true,
          slideDismissDirection: DismissDirection.horizontal,
          leading: const Icon(Icons.exposure_plus_1),
        );
        break;
      case 2:
        tapNotifier.value++;
        showSimpleNotification(
          const Text("Noch einmal, bleib stark. Sharezone braucht dich!"),
          autoDismiss: true,
          slideDismissDirection: DismissDirection.horizontal,
          leading: const Icon(Icons.exposure_plus_2),
        );
        break;
      case 3:
        tapNotifier.value++;
        showSimpleNotification(
          const Text(
              "Oh nein, Sharezone ist zu klein geworden 😧 Wir müssen es wieder vergrößern!"),
          autoDismiss: true,
          slideDismissDirection: DismissDirection.horizontal,
          leading: const Icon(Icons.thumb_down),
        );
        _executeEasterEgg();
        break;
      default:
        break;
    }
  }

  Future<void> _executeEasterEgg() async {
    final currentTextScalingFactor =
        context.read<ThemeSettings>().textScalingFactor;

    // Set the text scaling factor to 0.1 as an Easter egg
    context.read<ThemeSettings>().textScalingFactor = 0.1;

    // As an Easter egg, the text scaling factor will be changed 10 times
    // with a random value between 0 and 2.
    for (int i = 0; i < 10; i++) {
      final random = Random().nextDouble() * 2.0;

      context.read<ThemeSettings>().textScalingFactor = random;
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!context.mounted) return;

    // Reset the text scaling factor
    context.read<ThemeSettings>().textScalingFactor = currentTextScalingFactor;

    showSimpleNotification(
      const Text(
          "Puuuh, geschafft! Sharezone hat wieder die normale Größe! 🎉 #easter-egg"),
      autoDismiss: true,
      slideDismissDirection: DismissDirection.horizontal,
      leading: const Icon(Icons.thumb_up),
    );

    // Set the tap counter back to 0 to be able to trigger the Easter egg again.
    tapNotifier.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return AvatarCard(
      svgPath: "assets/logo",
      crossAxisAlignment: CrossAxisAlignment.center,
      avatarBackgroundColor: Colors.white,
      children: <Widget>[
        Text(
          "Sharezone",
          style: TextStyle(
            color:
                Theme.of(context).isDarkTheme ? Colors.white : Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Der vernetzte Schulplaner",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        FutureBuilder<PlatformInformationRetriever>(
          future: getPlatformInformationRetrieverWithInit(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Version wird geladen...");
            if (snapshot.hasError) {
              return Text("Fehler: ${snapshot.error.toString()}");
            }
            return Text(
              "Version: ${snapshot.data?.version} (${snapshot.data?.versionNumber})",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
            );
          },
        )
      ],
      onTapImage: () => _handleSharezoneLogoTap(),
    );
  }
}

class _FollowUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutSection(
      title: 'Folge uns',
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Text(
              "Folge uns auf unseren Kanälen, um immer auf dem neusten Stand zu bleiben.",
              style: _greyTextStyle(context),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SocialButton.instagram("https://sharezone.net/instagram"),
                SocialButton.twitter("https://sharezone.net/twitter"),
                SocialButton.discord("https://sharezone.net/discord"),
                SocialButton.github("https://sharezone.net/github"),
              ],
            )
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
      title: 'Was ist Sharezone?',
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                "Sharezone ist ein vernetzter Schulplaner, welcher die Organisation von Schülern, Lehrkräften und Eltern aus der"
                " Steinzeit in das digitale Zeitalter katapultiert. Das Hausaufgabenheft, der Terminplaner, die Dateiablage "
                "und vieles weitere wird direkt mit der kompletten Klasse geteilt. Dabei ist keine Registrierung der Schule und "
                "die Leitung einer Lehrkraft notwendig, so dass du direkt durchstarten und deinen Schulalltag bequem und "
                "einfach gestalten kannst.",
                style: _greyTextStyle(context),
              ),
              const SizedBox(height: 8),
              MarkdownBody(
                data:
                    "Besuche für weitere Informationen einfach https://www.sharezone.net.",
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        a: linkStyle(context), p: _greyTextStyle(context)),
                onTapLink: (url, _, __) => launchURL(url, context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
