// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_review/app_review.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/pages/settings/src/widgets/settings_subpage_settings.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../support_page.dart';

class ThemePage extends StatelessWidget {
  static const tag = 'theme-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Erscheinungsbild"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _DarkModeSwitch(),
                _NewNavigationExperiment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsSubpageSection(
      title: "Light & Dark Mode",
      children: const [
        _BrightnessRadioGroup(),
        _RateOurApp(),
      ],
    );
  }
}

class _BrightnessRadioGroup extends StatelessWidget {
  const _BrightnessRadioGroup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeBrightness = context.select<ThemeSettings, ThemeBrightness>(
        (settings) => settings.themeBrightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BrightnessRadio(
          title: "Heller Modus",
          groupValue: themeBrightness,
          icon: const Icon(Icons.brightness_high),
          themeBrightness: ThemeBrightness.light,
        ),
        _BrightnessRadio(
          title: "Dunkler Modus",
          groupValue: themeBrightness,
          icon: const Icon(Icons.brightness_low),
          themeBrightness: ThemeBrightness.dark,
        ),
        _BrightnessRadio(
          title: "System",
          groupValue: themeBrightness,
          icon: const Icon(Icons.settings_brightness),
          themeBrightness: ThemeBrightness.system,
        ),
      ],
    );
  }
}

class _BrightnessRadio extends StatelessWidget {
  const _BrightnessRadio({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.themeBrightness,
    @required this.groupValue,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final ThemeBrightness themeBrightness, groupValue;

  @override
  Widget build(BuildContext context) {
    final themeSettings = context.read<ThemeSettings>();

    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () => themeSettings.themeBrightness = themeBrightness,
      trailing: Radio<ThemeBrightness>(
        onChanged: (newBrightness) =>
            themeSettings.themeBrightness = newBrightness,
        value: themeBrightness,
        groupValue: groupValue,
      ),
    );
  }
}

class _RateOurApp extends StatelessWidget {
  const _RateOurApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AnnouncementCard(
        title: "Gefällt dir Sharezone?",
        color: isDarkThemeEnabled(context)
            ? ElevationColors.dp12
            : context.primaryColor.withOpacity(0.15),
        content: const Text(
          "Falls dir Sharezone gefällt, würden wir uns über eine Bewertung sehr freuen! 🙏  Dir gefällt etwas nicht? Kontaktiere einfach den Support 👍",
        ),
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: Row(
                children: const [
                  _ContactSupportButton(),
                  SizedBox(width: 12),
                  _RateAppButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewNavigationExperiment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Das Navigation-Experiment betrifft nur die Navigation für
    // kleine Geräte. Somit ist es für Nutzer mit großen Geräten nur
    // verwirrend, wenn diese die neue Navigation aktivieren, aber
    // nichts passiert.
    if (context.isDesktopModus) return Container();

    return SettingsSubpageSection(
      title: "Experiment: Neue Navigation",
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Wir testen aktuell eine neue Navigation. Bitte gib über die Feedback-Box oder unseren Discord-Server eine kurze Rückmeldung, wie du die jeweiligen Optionen findest.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        _NavigationRadioGroup(),
      ],
    );
  }
}

class _NavigationRadioGroup extends StatelessWidget {
  const _NavigationRadioGroup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      stream: navigationCache.currentNavigation,
      initialData: navigationCache.currentNavigation.valueOrNull,
      builder: (context, snapshot) {
        final option = snapshot.data ?? NavigationExperimentOption.drawerAndBnb;
        return Column(
          children: [
            for (int i = 0; i < NavigationExperimentOption.values.length; i++)
              _NavigationRadioTile(
                currentValue: option,
                option: NavigationExperimentOption.values[i],
                number: i + 1,
              ),
          ],
        );
      },
    );
  }
}

class _RateAppButton extends StatelessWidget {
  const _RateAppButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: context.primaryColor,
      textColor: Colors.white,
      onPressed: () {
        if (PlatformCheck.isWeb) {
          _showAppRatingIsNotAvailableOnWeb(context);
          return;
        }

        // Die In-App-Bewertung funktioniert momentan nur über iOS zuverlässig.
        // Aus diesem Grund soll für andere Plattformen einfach der Store-Link
        // geöffnet werden, solange es noch nicht zuverlässig funktioniert.
        if (PlatformCheck.isIOS) {
          _launchInAppReview();
          return;
        }

        launchURL(_getStoreLink());
      },
      child: Text("Bewerten".toUpperCase()),
      elevation: 0,
      highlightElevation: 0,
    );
  }

  Future<void> _launchInAppReview() async {
    AppReview.requestReview;
  }

  String _getStoreLink() {
    const sharezoneLink = 'https://sharezone.net';
    if (PlatformCheck.isAndroid) return '$sharezoneLink/android';
    if (PlatformCheck.isIOS) return '$sharezoneLink/ios';
    if (PlatformCheck.isMacOS) return '$sharezoneLink/macos';
    return sharezoneLink;
  }

  void _showAppRatingIsNotAvailableOnWeb(BuildContext context) {
    showLeftRightAdaptiveDialog(
      context: context,
      title: 'App-Bewertung nur über iOS & Android möglich!',
      content: Text(
          'Über die Web-App kann die App nicht bewertet werden. Nimm dafür einfach dein Handy 👍'),
      left: AdaptiveDialogAction.ok,
    );
  }
}

class _NavigationRadioTile extends StatelessWidget {
  const _NavigationRadioTile({
    Key key,
    this.option,
    this.number,
    this.currentValue,
  }) : super(key: key);

  final NavigationExperimentOption currentValue;
  final NavigationExperimentOption option;
  final int number;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Text('Option $number: ${option.toReadableString()}'),
        onTap: () => onTap(context),
        trailing: Radio(
          value: option,
          groupValue: currentValue,
          onChanged: (_) => onTap(context),
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    navigationCache.setNavigation(option);
    if (option != NavigationExperimentOption.drawerAndBnb) {
      popToShowBnbTutorial(context);
    }
  }

  /// Pops to the settings page to show the [ExtenableBottomNavigationBar] and
  /// [BnbTutorial] ([ThemePage] has no navigation, like a BottonNavigationBar
  /// or a Drawer).
  Future<void> popToShowBnbTutorial(BuildContext context) async {
    final bloc = BlocProvider.of<BnbTutorialBloc>(context);
    if (await bloc.shouldShowBnbTutorial().first) {
      Navigator.pop(context);
    }
  }
}

class _ContactSupportButton extends StatelessWidget {
  const _ContactSupportButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, SupportPage.tag),
      child: Text("Support kontaktieren".toUpperCase()),
      style: TextButton.styleFrom(
        foregroundColor:
            isDarkThemeEnabled(context) ? Colors.grey : Colors.grey[600],
      ),
    );
  }
}
