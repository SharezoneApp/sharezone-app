// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharezone/legal/terms_of_service/terms_of_service_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/settings/src/subpages/changelog_page.dart';
import 'package:sharezone/settings/src/subpages/notification.dart';
import 'package:sharezone/settings/src/subpages/about/about_page.dart';
import 'package:sharezone/settings/src/subpages/theme/theme_page.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/settings/src/subpages/timetable/timetable_settings_page.dart';
import 'package:sharezone/settings/src/subpages/web_app.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/subpages/my_profile/my_profile_page.dart';
import 'package:sharezone/settings/src/subpages/imprint/analytics/imprint_analytics.dart';
import 'package:sharezone/settings/src/subpages/imprint/page/imprint_page.dart';

class SettingsPage extends StatelessWidget {
  static const String tag = "settings-page";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharezoneMainScaffold(
      body: SettingsPageBody(),
      navigationItem: NavigationItem.settings,
    );
  }
}

class SettingsPageBody extends StatelessWidget {
  static const double _spaceBetween = 16.0;

  const SettingsPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        popToOverview(context);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _AppSettingsSection(),
                const SizedBox(height: _spaceBetween),
                _MoreSection(),
                const SizedBox(height: _spaceBetween),
                _LegalSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return SafeArea(
      bottom: true,
      child: _SettingsSection(
        title: "Rechtliches",
        children: <Widget>[
          _SettingsOption(
            title: "Datenschutzerklärung",
            icon: const Icon(Icons.security),
            onTap: () {
              _logOpenPrivacyPolicy(analytics);
              Navigator.pushNamed(context, PrivacyPolicyPage.tag);
            },
          ),
          _SettingsOption(
            title: "Allgemeine Nutzungsbedingungen (ANB)",
            icon: const Icon(Icons.description),
            onTap: () {
              _logOpenPrivacyPolicy(analytics);
              Navigator.pushNamed(context, TermsOfServicePage.tag);
            },
          ),
          _SettingsOption(
            title: "Impressum",
            icon: const Icon(Icons.account_balance),
            onTap: () {
              _logOpenImprint(context);
              Navigator.pushNamed(context, ImprintPage.tag);
            },
          ),
          _SettingsOption(
            title: "Lizenzen",
            icon: const Icon(Icons.layers),
            onTap: () => _openLicensePage(context),
          ),
        ],
      ),
    );
  }

  void _openLicensePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LicensePage(),
        settings: const RouteSettings(name: 'license-page'),
      ),
    );
  }

  void _logOpenImprint(BuildContext context) {
    final analytics = BlocProvider.of<ImprintAnalytics>(context);
    analytics.logOpenImprint();
  }

  void _logOpenPrivacyPolicy(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "open_privacy_policy"));
  }
}

class _AppSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _SettingsSection(
      title: 'App-Einstellungen',
      children: <Widget>[
        _SettingsOption(
          title: "Mein Konto",
          icon: Icon(Icons.account_circle),
          tag: MyProfilePage.tag,
        ),
        _SettingsOption(
          title: "Benachrichtigungen",
          icon: Icon(Icons.notifications_active),
          tag: NotificationPage.tag,
        ),
        _SettingsOption(
          title: "Erscheinungsbild",
          icon: Icon(Icons.color_lens),
          tag: ThemePage.tag,
        ),
        _SettingsOption(
          title: "Stundenplan",
          icon: Icon(Icons.access_time),
          tag: TimetableSettingsPage.tag,
        )
      ],
    );
  }
}

class _MoreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: "Mehr",
      children: <Widget>[
        const _SettingsOption(
          title: "Über uns",
          icon: Icon(Icons.info),
          tag: AboutPage.tag,
        ),
        _SettingsOption(
          title: "Quellcode",
          icon: SvgPicture.asset(
            'assets/icons/github.svg',
            colorFilter: ColorFilter.mode(
              Theme.of(context).listTileTheme.iconColor!,
              BlendMode.srcIn,
            ),
          ),
          onTap: () => launchURL(
            'https://sharezone.net/github',
            context: context,
          ),
        ),
        if (!PlatformCheck.isDesktopOrWeb)
          const _SettingsOption(
            title: "Web-App",
            icon: Icon(Icons.desktop_mac),
            tag: WebAppSettingsPage.tag,
          ),
        const _SettingsOption(
          title: "Support",
          icon: Icon(Icons.question_answer),
          tag: SupportPage.tag,
        ),
        const _SettingsOption(
          title: "Was ist neu?",
          icon: Icon(Icons.assignment),
          tag: ChangelogPage.tag,
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({this.title, this.children});

  final String? title;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Headline(title!),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children!,
          ),
        )
      ],
    );
  }
}

// Entweder eigene onTap übergeben oder einfach das Widget für die Navigation übergeben
class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
    this.title,
    this.icon,
    this.onTap,
    this.tag,
  });

  final String? title;
  final Widget? icon;
  final GestureTapCallback? onTap;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title!),
      leading: icon,
      onTap: onTap ?? () => Navigator.pushNamed(context, tag!),
    );
  }
}
