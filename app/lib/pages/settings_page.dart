import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/pages/settings/changelog_page.dart';
import 'package:sharezone/pages/settings/license.dart';
import 'package:sharezone/pages/settings/notification.dart';
import 'package:sharezone/pages/settings/src/subpages/about/about_page.dart';
import 'package:sharezone/pages/settings/src/subpages/privacy_policy/privacy_policy.dart';
import 'package:sharezone/pages/settings/src/subpages/theme/theme_page.dart';
import 'package:sharezone/pages/settings/support_page.dart';
import 'package:sharezone/pages/settings/timetable_settings/timetable_settings_page.dart';
import 'package:sharezone/pages/settings/web_app.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';

import 'settings/my_profile/my_profile_page.dart';
import 'settings/src/subpages/imprint/analytics/imprint_analytics.dart';
import 'settings/src/subpages/imprint/page/imprint_page.dart';

class SettingsPage extends StatelessWidget {
  static const String tag = "settings-page";

  @override
  Widget build(BuildContext context) {
    return SharezoneMainScaffold(
      body: _SettingsPageBody(),
      navigationItem: NavigationItem.settings,
    );
  }
}

class _SettingsPageBody extends StatelessWidget {
  static const double _spaceBetween = 16.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popToOverview(context),
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
            icon: Icons.security,
            onTap: () {
              _logOpenPrivacyPolicy(analytics);
              Navigator.pushNamed(context, PrivacyPolicy.tag);
            },
          ),
          _SettingsOption(
            title: "Impressum",
            icon: Icons.account_balance,
            onTap: () {
              _logOpenImprint(context);
              Navigator.pushNamed(context, ImprintPage.tag);
            },
          ),
          _SettingsOption(
            title: "Lizenzen",
            icon: Icons.layers,
            tag: LicensesPage.tag,
          ),
        ],
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
    return _SettingsSection(
      title: 'App-Einstellungen',
      children: <Widget>[
        _SettingsOption(
          title: "Mein Konto",
          icon: Icons.account_circle,
          tag: MyProfilePage.tag,
        ),
        _SettingsOption(
          title: "Benachrichtigungen",
          icon: Icons.notifications_active,
          tag: NotificationPage.tag,
        ),
        _SettingsOption(
          title: "Erscheinungsbild",
          icon: Icons.color_lens,
          tag: ThemePage.tag,
        ),
        _SettingsOption(
          title: "Stundenplan",
          icon: Icons.access_time,
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
        _SettingsOption(
          title: "Über uns",
          icon: Icons.info,
          tag: AboutPage.tag,
        ),
        if (!PlatformCheck.isDesktopOrWeb)
          _SettingsOption(
            title: "Web-App",
            icon: Icons.desktop_mac,
            tag: WebAppSettingsPage.tag,
          ),
        _SettingsOption(
          title: "Häufige Fragen",
          icon: Icons.live_help,
          onTap: () => launchURL("https://sharezone.net/faq"),
        ),
        _SettingsOption(
          title: "Support",
          icon: Icons.question_answer,
          tag: SupportPage.tag,
        ),
        _SettingsOption(
          title: "Was ist neu?",
          icon: Icons.assignment,
          tag: ChangelogPage.tag,
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({Key key, this.title, this.children})
      : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Headline(title),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
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
    this.enabled,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final bool enabled;
  final GestureTapCallback onTap;
  final String tag;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      enabled: enabled ?? true,
      onTap: onTap != null ? onTap : () => Navigator.pushNamed(context, tag),
      trailing: trailing,
    );
  }
}
