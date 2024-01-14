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
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone/settings/src/widgets/settings_subpage_settings.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ThemePage extends StatelessWidget {
  static const tag = 'theme-page';

  const ThemePage({super.key});

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
    final themeBrightness = context.select<ThemeSettings, ThemeBrightness>(
        (settings) => settings.themeBrightness);

    return SettingsSubpageSection(
      title: "Light & Dark Mode",
      children: [
        Column(
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
        ),
      ],
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
      trailing: Radio<ThemeBrightness>(
        onChanged: (newBrightness) =>
            themeSettings.themeBrightness = newBrightness!,
        value: themeBrightness,
        groupValue: groupValue,
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

    return const SettingsSubpageSection(
      title: "Experiment: Neue Navigation",
      children: <Widget>[
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
  const _NavigationRadioGroup();

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

class _NavigationRadioTile extends StatelessWidget {
  const _NavigationRadioTile({
    this.option,
    this.number,
    this.currentValue,
  });

  final NavigationExperimentOption? currentValue;
  final NavigationExperimentOption? option;
  final int? number;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Text('Option $number: ${option!.toReadableString()}'),
        onTap: () => onTap(context),
        trailing: Radio(
          value: option,
          groupValue: currentValue,
          onChanged: (dynamic _) => onTap(context),
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    navigationCache.setNavigation(option!);
    if (option != NavigationExperimentOption.drawerAndBnb) {
      popToShowBnbTutorial(context);
    }
  }

  /// Pops to the settings page to show the [ExtenableBottomNavigationBar] and
  /// [BnbTutorial] ([ThemePage] has no navigation, like a BottonNavigationBar
  /// or a Drawer).
  Future<void> popToShowBnbTutorial(BuildContext context) async {
    final bloc = BlocProvider.of<BnbTutorialBloc>(context);
    if (await bloc.shouldShowBnbTutorial().first && context.mounted) {
      Navigator.pop(context);
    }
  }
}
