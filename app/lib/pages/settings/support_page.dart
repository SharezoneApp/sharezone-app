// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  static const String tag = 'support-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12)
            .add(const EdgeInsets.only(bottom: 12)),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Header(),
                _DiscordTile(),
                _EmailTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return AvatarCard(
      crossAxisAlignment: CrossAxisAlignment.center,
      avatarBackgroundColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: SizedBox(
          width: 70,
          height: 70,
          child: PlatformSvg.asset('assets/icons/confused.svg'),
        ),
      ),
      children: const <Widget>[
        Text(
          'Du brauchst Hilfe?',
          style: TextStyle(fontSize: 26),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Kontaktiere uns einfach über einen Kanal deiner Wahl und wir werden dir schnellstmöglich weiterhelfen 😉\n\nBitte beachte, dass es manchmal länger dauern kann, bis wir antworten (1-2 Wochen).',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CustomCard(
        child: ListTile(
          leading: SizedBox(
            width: 30,
            height: 30,
            child: icon,
          ),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          onTap: onPressed,
        ),
      ),
    );
  }
}

class _EmailTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: PlatformSvg.asset(
        'assets/icons/email.svg',
        color: context.primaryColor,
      ),
      title: 'E-Mail',
      subtitle: 'support@sharezone.net',
      onPressed: () async {
        final url = Uri.parse(Uri.encodeFull(
            'mailto:support@sharezone.net?subject=Ich brauche eure Hilfe! 😭'));
        try {
          await launchUrl(url);
        } on Exception catch (_) {
          showSnackSec(
            context: context,
            text: 'E-Mail: support@sharezone.net',
          );
        }
      },
    );
  }
}

class _DiscordTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: PlatformSvg.asset(
        'assets/icons/discord.svg',
        color: context.primaryColor,
      ),
      title: 'Discord',
      subtitle: 'Community-Support',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => _NoteAboutPrivacyPolicy(),
        );

        if (confirmed == true) {
          launchURL('https://sharezone.net/discord', context: context);
        }
      },
    );
  }
}

class _NoteAboutPrivacyPolicy extends StatelessWidget {
  const _NoteAboutPrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Discord Datenschutz"),
      content: SingleChildScrollView(
        child: MarkdownBody(
          data:
              "Bitte beachte, dass bei der Nutzung von Discord dessen [Datenschutzbestimmungen](https://discord.com/privacy) gelten.",
          styleSheet: MarkdownStyleSheet(a: linkStyle(context, 14)),
          onTapLink: (_, url, __) {
            if (url == null) return;
            launchURL(url, context: context);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("ABBRECHEN"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("WEITER"),
        ),
      ],
    );
  }
}
