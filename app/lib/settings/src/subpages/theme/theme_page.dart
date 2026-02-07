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
import 'package:in_app_review/in_app_review.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/settings/src/widgets/settings_subpage_settings.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ThemePage extends StatelessWidget {
  static const tag = 'theme-page';

  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.themeTitle), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_DarkModeSwitch(), _NewNavigationExperiment()],
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
      title: context.l10n.themeLightDarkModeSectionTitle,
      children: const [_BrightnessRadioGroup(), _RateOurApp()],
    );
  }
}

class _BrightnessRadioGroup extends StatelessWidget {
  const _BrightnessRadioGroup();

  @override
  Widget build(BuildContext context) {
    final themeBrightness = context.select<ThemeSettings, ThemeBrightness>(
      (settings) => settings.themeBrightness,
    );

    return RadioGroup(
      groupValue: themeBrightness,
      onChanged: (value) {
        if (value == null) return;
        final themeSettings = context.read<ThemeSettings>();
        themeSettings.themeBrightness = value;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BrightnessRadio(
            title: context.l10n.themeLightMode,
            groupValue: themeBrightness,
            icon: const Icon(Icons.brightness_high),
            themeBrightness: ThemeBrightness.light,
          ),
          _BrightnessRadio(
            title: context.l10n.themeDarkMode,
            groupValue: themeBrightness,
            icon: const Icon(Icons.brightness_low),
            themeBrightness: ThemeBrightness.dark,
          ),
          _BrightnessRadio(
            title: context.l10n.themeSystemMode,
            groupValue: themeBrightness,
            icon: const Icon(Icons.settings_brightness),
            themeBrightness: ThemeBrightness.system,
          ),
        ],
      ),
    );
  }
}

class _BrightnessRadio extends StatelessWidget {
  const _BrightnessRadio({
    required this.icon,
    required this.title,
    required this.themeBrightness,
    required this.groupValue,
  });

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
      trailing: Radio<ThemeBrightness>(value: themeBrightness),
    );
  }
}

class _RateOurApp extends StatelessWidget {
  const _RateOurApp();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AnnouncementCard(
        title: context.l10n.themeRateOurAppCardTitle,
        color:
            Theme.of(context).isDarkTheme
                ? ElevationColors.dp12
                : context.primaryColor.withValues(alpha: 0.15),
        content: Text(context.l10n.themeRateOurAppCardContent),
        actions: const [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: Row(
                children: [
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
      title: context.l10n.themeNavigationExperimentSectionTitle,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.themeNavigationExperimentSectionContent,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const _NavigationRadioGroup(),
      ],
    );
  }
}

class _NavigationRadioGroup extends StatelessWidget {
  const _NavigationRadioGroup();

  /// Pops to the settings page to show the [ExtenableBottomNavigationBar] and
  /// [BnbTutorial] ([ThemePage] has no navigation, like a BottonNavigationBar
  /// or a Drawer).
  Future<void> popToShowBnbTutorial(BuildContext context) async {
    final bloc = BlocProvider.of<BnbTutorialBloc>(context);
    if (await bloc.shouldShowBnbTutorial().first && context.mounted) {
      Navigator.pop(context);
    }
  }

  void onChange(NavigationExperimentOption option, BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    navigationCache.setNavigation(option);
    if (option != NavigationExperimentOption.drawerAndBnb) {
      popToShowBnbTutorial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      stream: navigationCache.currentNavigation,
      initialData: navigationCache.currentNavigation.valueOrNull,
      builder: (context, snapshot) {
        final option = snapshot.data ?? NavigationExperimentOption.drawerAndBnb;
        return RadioGroup(
          groupValue: option,
          onChanged: (value) {
            if (value == null) return;
            onChange(value, context);
          },
          child: Column(
            children: [
              for (int i = 0; i < NavigationExperimentOption.values.length; i++)
                _NavigationRadioTile(
                  option: NavigationExperimentOption.values[i],
                  onTap: (value) => onChange(value, context),
                  number: i + 1,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RateAppButton extends StatelessWidget {
  const _RateAppButton();

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
      elevation: 0,
      highlightElevation: 0,
      child: Text(context.l10n.themeRateOurAppCardRateButton.toUpperCase()),
    );
  }

  Future<void> _launchInAppReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
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
      title:
          context.l10n.themeRateOurAppCardRatingsNotAvailableOnWebDialogTitle,
      content: Text(
        context.l10n.themeRateOurAppCardRatingsNotAvailableOnWebDialogContent,
      ),
      left: AdaptiveDialogAction.ok(context),
    );
  }
}

class _NavigationRadioTile extends StatelessWidget {
  const _NavigationRadioTile({
    required this.option,
    this.number,
    required this.onTap,
  });

  final NavigationExperimentOption option;
  final int? number;
  final ValueChanged<NavigationExperimentOption> onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Text('Option $number: ${option.getDisplayName(context)}'),
        onTap: () => onTap(option),
        trailing: Radio(value: option),
      ),
    );
  }
}

class _ContactSupportButton extends StatelessWidget {
  const _ContactSupportButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, SupportPage.tag),
      style: TextButton.styleFrom(
        foregroundColor:
            Theme.of(context).isDarkTheme ? Colors.grey : Colors.grey[600],
      ),
      child: Text(context.l10n.contactSupportButton.toUpperCase()),
    );
  }
}
