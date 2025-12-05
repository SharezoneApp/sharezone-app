// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialButtonTypes { linkedIn, instagram, twitter, discord, email }

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.svgPath,
    required this.tooltip,
    required this.link,
    required this.socialButtonTypes,
  });

  SocialButton.instagram(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.instagram,
      svgPath = 'assets/icons/instagram.svg',
      socialButtonTypes = SocialButtonTypes.instagram;

  SocialButton.twitter(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.twitter,
      svgPath = 'assets/icons/twitter.svg',
      socialButtonTypes = SocialButtonTypes.twitter;

  SocialButton.linkedIn(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.linkedIn,
      svgPath = 'assets/icons/linkedin.svg',
      socialButtonTypes = SocialButtonTypes.linkedIn;

  SocialButton.discord(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.discord,
      svgPath = 'assets/icons/discord.svg',
      socialButtonTypes = SocialButtonTypes.linkedIn;

  SocialButton.email(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.email,
      svgPath = 'assets/icons/email.svg',
      socialButtonTypes = SocialButtonTypes.email;

  SocialButton.github(BuildContext context, this.link, {super.key})
    : tooltip = context.l10n.gitHub,
      svgPath = 'assets/icons/github.svg',
      socialButtonTypes = SocialButtonTypes.linkedIn;

  final String link, tooltip, svgPath;
  final SocialButtonTypes socialButtonTypes;
  static const double _svgSize = 28;

  Future<void> onPressed(BuildContext context) async {
    if (socialButtonTypes != SocialButtonTypes.email) {
      launchURL(link);
    } else {
      try {
        final url = Uri.parse(Uri.encodeFull("mailto:$link"));
        await launchUrl(url);
      } on Exception catch (_) {
        if (!context.mounted) return;
        showSnackSec(
          text: context.l10n.aboutPageEmailCopiedConfirmation(link),
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
      icon: SvgPicture.asset(
        svgPath,
        width: _svgSize,
        height: _svgSize,
        colorFilter: ColorFilter.mode(
          Theme.of(context).primaryColor,
          BlendMode.srcIn,
        ),
      ),
      iconSize: _svgSize,
    );
  }
}
