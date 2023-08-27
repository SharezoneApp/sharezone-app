// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialButtonTypes {
  linkedIn,
  instagram,
  twitter,
  discord,
  email,
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.svgPath,
    required this.tooltip,
    required this.link,
    required this.socialButtonTypes,
  });

  const SocialButton.instagram(this.link)
      : tooltip = 'Instagram',
        svgPath = 'assets/icons/instagram.svg',
        socialButtonTypes = SocialButtonTypes.instagram;

  const SocialButton.twitter(this.link)
      : tooltip = 'Twitter',
        svgPath = 'assets/icons/twitter.svg',
        socialButtonTypes = SocialButtonTypes.twitter;

  const SocialButton.linkedIn(this.link)
      : tooltip = 'LinkedIn',
        svgPath = 'assets/icons/linkedin.svg',
        socialButtonTypes = SocialButtonTypes.linkedIn;

  const SocialButton.discord(this.link)
      : tooltip = 'Discord',
        svgPath = 'assets/icons/discord.svg',
        socialButtonTypes = SocialButtonTypes.linkedIn;

  const SocialButton.email(this.link)
      : tooltip = 'E-Mail',
        svgPath = 'assets/icons/email.svg',
        socialButtonTypes = SocialButtonTypes.email;

  final String link, tooltip, svgPath;
  final SocialButtonTypes socialButtonTypes;
  static const double _svgSize = 28;

  Future<void> onPressed(BuildContext context) async {
    if (socialButtonTypes != SocialButtonTypes.email)
      launchURL(link);
    else {
      try {
        final url = Uri.parse(Uri.encodeFull("mailto:$link"));
        await launchUrl(url);
      } on Exception catch (_) {
        showSnackSec(
          text: "E-Mail: $link",
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => onPressed(context),
      icon: PlatformSvg.asset(
        svgPath,
        width: _svgSize,
        height: _svgSize,
        color: Theme.of(context).primaryColor,
      ),
      iconSize: _svgSize,
    );
  }
}
