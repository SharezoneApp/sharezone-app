// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/widgets/avatar_card.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/section.dart';

const phoneNumber = '+49 1516 7754541';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const String tag = 'support';

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        Section(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _Header(),
              _EmailTile(),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
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
            child: SvgPicture.asset('assets/icons/confused.svg')),
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
  final Widget? icon;
  final String? title, subtitle;
  final VoidCallback? onPressed;

  const _SupportCard({this.icon, this.title, this.subtitle, this.onPressed});

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
          title: Text(title!),
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
      icon: SvgPicture.asset(
        'assets/icons/email.svg',
        theme: SvgTheme(currentColor: Theme.of(context).primaryColor),
      ),
      title: 'support@sharezone.net',
      subtitle: 'E-Mail',
      onPressed: () async {
        final uri = Uri.parse(
            'mailto:support@sharezone.net?subject=Ich brauche eure Hilfe! 😭');
        try {
          await launchUrl(uri);
        } catch (e) {
          if (!context.mounted) return;
          showSnackSec(
            context: context,
            text: 'E-Mail: support@sharezone.net',
          );
        }
      },
    );
  }
}
