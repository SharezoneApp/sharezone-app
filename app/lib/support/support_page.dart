// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/support/support_page_controller.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SupportPage extends StatelessWidget {
  static const String tag = 'support-page';

  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SupportPageController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.supportPageTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ).add(const EdgeInsets.only(bottom: 12)),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _Header(),
                const SizedBox(height: 12),
                if (controller.hasPlusSupportUnlocked)
                  const _PlusSupport()
                else ...[
                  const _FreeSupport(),
                  // We only show the advertising if the user is signed in
                  // because a logged out user can't buy Sharezone Plus.
                  //
                  // Also we don't show the advertising if the user is in the
                  // group onboarding because for two reasons:
                  //
                  // 1. The user opened the app for the first time a few
                  //    minutes ago and we don't want to overwhelm them with
                  //    buying Sharezone Plus.
                  // 2. With the current onboarding navigation system,
                  //    navigating to the Sharezone Plus page would require
                  //    the user to leave the onboarding and we don't want
                  //    that.
                  if (controller.isUserSignedIn &&
                      !controller.isUserInGroupOnboarding) ...const [
                    SizedBox(height: 16),
                    _SharezonePlusAdvertising(),
                  ],
                ],
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
          child: SvgPicture.asset('assets/icons/confused.svg'),
        ),
      ),
      children: <Widget>[
        Text(
          context.l10n.supportPageHeadline,
          style: const TextStyle(fontSize: 26),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.l10n.supportPageBody,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _FreeSupport extends StatelessWidget {
  const _FreeSupport();

  @override
  Widget build(BuildContext context) {
    return _SupportPlanBase(
      key: const ValueKey('free-support'),
      title: Text(context.l10n.supportPageFreeSupportTitle),
      subtitle: Text(context.l10n.supportPageFreeSupportSubtitle),
      body: const Column(children: [_DiscordTile(), _FreeEmailTile()]),
    );
  }
}

class _PlusSupport extends StatelessWidget {
  const _PlusSupport();

  @override
  Widget build(BuildContext context) {
    return _SupportPlanBase(
      key: const ValueKey('plus-support'),
      title: Text(context.l10n.supportPagePlusSupportTitle),
      subtitle: Text(context.l10n.supportPagePlusSupportSubtitle),
      body: const Column(
        children: [_PlusEmailTile(), _VideoCallTile(), _DiscordTile()],
      ),
    );
  }
}

class _SupportPlanBase extends StatelessWidget {
  const _SupportPlanBase({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultTextStyle.merge(
          child: title,
          style: const TextStyle(fontSize: 22),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          DefaultTextStyle.merge(
            child: subtitle!,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 4),
        body,
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onPressed,
  });

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
          leading: SizedBox(width: 30, height: 30, child: icon),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          onTap: onPressed,
        ),
      ),
    );
  }
}

/// The tile that is used for the free email support in [_FreeSupport].
class _FreeEmailTile extends StatelessWidget {
  const _FreeEmailTile();

  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: SvgPicture.asset(
        'assets/icons/email.svg',
        colorFilter: ColorFilter.mode(context.primaryColor, BlendMode.srcIn),
        semanticsLabel: context.l10n.supportPageEmailIconSemanticsLabel,
      ),
      title: context.l10n.supportPageEmailTitle,
      subtitle: freeSupportEmail,
      onPressed: () async {
        try {
          final controller = context.read<SupportPageController>();
          await controller.sendEmailToFreeSupport();
        } on Exception catch (_) {
          if (!context.mounted) return;
          showSnackSec(
            context: context,
            text: context.l10n.supportPageEmailAddress(freeSupportEmail),
          );
        }
      },
    );
  }
}

/// The tile that is used for the free email support in [_FreeSupport].
class _PlusEmailTile extends StatelessWidget {
  const _PlusEmailTile();

  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: SvgPicture.asset(
        'assets/icons/email.svg',
        colorFilter: ColorFilter.mode(context.primaryColor, BlendMode.srcIn),
        semanticsLabel: context.l10n.supportPageEmailIconSemanticsLabel,
      ),
      title: context.l10n.supportPageEmailTitle,
      subtitle: context.l10n.supportPagePlusEmailSubtitle,
      onPressed: () async {
        try {
          final controller = context.read<SupportPageController>();
          await controller.sendEmailToPlusSupport();
        } on Exception catch (_) {
          if (!context.mounted) return;
          showSnackSec(
            context: context,
            text: context.l10n.supportPageEmailAddress(plusSupportEmail),
          );
        }
      },
    );
  }
}

class _VideoCallTile extends StatelessWidget {
  const _VideoCallTile();

  void launchVideoCallPage(BuildContext context) {
    try {
      final url =
          context
              .read<SupportPageController>()
              .getVideoCallAppointmentsUnencodedUrlWithPrefills();
      launchURL(url, context: context);
    } on UserNotAuthenticatedException catch (_) {
      showSnackSec(
        context: context,
        text: context.l10n.supportPageVideoCallRequiresSignIn,
      );
    } on Exception catch (_) {
      showSnackSec(context: context, text: context.l10n.commonErrorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: Icon(Icons.video_call, color: context.primaryColor),
      title: context.l10n.supportPageVideoCallTitle,
      subtitle: context.l10n.supportPageVideoCallSubtitle,
      onPressed: () => launchVideoCallPage(context),
    );
  }
}

class _SharezonePlusAdvertising extends StatelessWidget {
  const _SharezonePlusAdvertising();

  void _navigateToSharezonePlusPage(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    Navigator.popUntil(context, ModalRoute.withName('/'));
    navigationBloc.navigateTo(NavigationItem.sharezonePlus);
  }

  @override
  Widget build(BuildContext context) {
    return _SupportPlanBase(
      key: const ValueKey('sharezone-plus-advertising'),
      title: Text(context.l10n.supportPagePlusSupportTitle),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: double.infinity,
          child: SharezonePlusFeatureInfoCard(
            withLearnMoreButton: true,
            onLearnMorePressed: () => _navigateToSharezonePlusPage(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(context.l10n.supportPagePlusSupportSubtitle),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data:
                        '''- ${context.l10n.supportPagePlusAdvertisingBulletOne}
- ${context.l10n.supportPagePlusAdvertisingBulletTwo}''',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscordTile extends StatelessWidget {
  const _DiscordTile();

  @override
  Widget build(BuildContext context) {
    return _SupportCard(
      icon: SvgPicture.asset(
        'assets/icons/discord.svg',
        colorFilter: ColorFilter.mode(context.primaryColor, BlendMode.srcIn),
        semanticsLabel: context.l10n.supportPageDiscordIconSemanticsLabel,
      ),
      title: context.l10n.supportPageDiscordTitle,
      subtitle: context.l10n.supportPageDiscordSubtitle,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => const _NoteAboutPrivacyPolicy(),
        );

        if (confirmed == true && context.mounted) {
          launchURL('https://sharezone.net/discord', context: context);
        }
      },
    );
  }
}

class _NoteAboutPrivacyPolicy extends StatelessWidget {
  const _NoteAboutPrivacyPolicy();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.supportPageDiscordPrivacyTitle),
      content: SingleChildScrollView(
        child: MarkdownBody(
          data: context.l10n.supportPageDiscordPrivacyContent,
          styleSheet: MarkdownStyleSheet(a: linkStyle(context, 14)),
          onTapLink: (_, url, _) {
            if (url == null) return;
            launchURL(url, context: context);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonActionsCancelUppercase),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.l10n.commonActionsContinue.toUpperCase()),
        ),
      ],
    );
  }
}
