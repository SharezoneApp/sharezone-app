// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class DisplaySettingsDialog extends StatelessWidget {
  const DisplaySettingsDialog({Key? key, required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    // Because of the way Flutter works our dialog will not use the same context
    // as the privacy policy page. This means we must manually apply our privacy
    // policy theme settings here again so that if the user changes these theme
    // settings this dialog also changes accordingly.
    return AnimatedBuilder(
      animation: themeSettings,
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(themeSettings.textScalingFactor),
        ),
        child: Theme(
          data: ThemeData(
              brightness:
                  _getBrightness(context, themeSettings.themeBrightness)),
          child: SimpleDialog(
            title: const Text('Anzeigeeinstellungen'),
            children: [
              _TextSize(themeSettings: themeSettings),
              const SizedBox(height: 20),
              _LightOrDarkMode(themeSettings: themeSettings),
              const SizedBox(height: 10),
              _VisualDensity(themeSettings: themeSettings),
              if (kDebugMode) ...[
                const SizedBox(height: 10),
                _DrawDebugThresholdIndicator(themeSettings: themeSettings),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

Brightness _getBrightness(
    BuildContext context, ThemeBrightness themeBrightness) {
  switch (themeBrightness) {
    case ThemeBrightness.dark:
      return Brightness.dark;
    case ThemeBrightness.light:
      return Brightness.light;
    default:
  }
  return MediaQuery.of(context).platformBrightness;
}

class _TextSize extends StatelessWidget {
  const _TextSize({Key? key, required this.themeSettings}) : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Textskalierungsfaktor',
              style: Theme.of(context).textTheme.labelLarge),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.bodyMedium!.color!,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final scalingFactor = themeSettings.textScalingFactor;
                    // We use this calulation instead of `textScalingFactor -
                    // 0.1` so we don't cause floating point errors (e.g. values
                    // like 1.0999999999999999)
                    const valueToSubtract = 0.1;
                    themeSettings.textScalingFactor =
                        (scalingFactor * 10 - valueToSubtract * 10) / 10;
                  },
                ),
                Text('${themeSettings.textScalingFactor}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final scalingFactor = themeSettings.textScalingFactor;
                    const valueToAdd = 0.1;
                    themeSettings.textScalingFactor =
                        (scalingFactor * 10 + valueToAdd * 10) / 10;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LightOrDarkMode extends StatelessWidget {
  const _LightOrDarkMode({Key? key, required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Dunkel-/Hellmodus',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 10),
          Column(
            children: [
              ToggleButtons(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                selectedColor: Theme.of(context).isDarkTheme
                    ? Colors.black.withAlpha(240)
                    : null, // standard color
                fillColor: Theme.of(context).isDarkTheme
                    ? blueColor
                    : null, // standard color
                borderColor: Theme.of(context).textTheme.bodyMedium!.color,
                selectedBorderColor:
                    Theme.of(context).textTheme.bodyMedium!.color,
                isSelected: [
                  themeSettings.themeBrightness == ThemeBrightness.dark,
                  themeSettings.themeBrightness == ThemeBrightness.light,
                  themeSettings.themeBrightness == ThemeBrightness.system,
                ],
                onPressed: (index) {
                  final brightness = <int, ThemeBrightness>{
                    0: ThemeBrightness.dark,
                    1: ThemeBrightness.light,
                    2: ThemeBrightness.system,
                  }[index]!;

                  themeSettings.themeBrightness = brightness;
                },
                children: const [
                  Icon(Icons.dark_mode),
                  Icon(Icons.light_mode),
                  Icon(Icons.settings_brightness),
                ],
              ),
              Text(_getText()!)
            ],
          ),
        ],
      ),
    );
  }

  String? _getText() {
    return <ThemeBrightness, String>{
      ThemeBrightness.dark: 'Dunkler Modus',
      ThemeBrightness.light: 'Heller Modus',
      ThemeBrightness.system: 'Automatisch',
    }[themeSettings.themeBrightness];
  }
}

class _VisualDensity extends StatelessWidget {
  const _VisualDensity({Key? key, required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Visuelle Kompaktheit',
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: 10),
        DropdownButton<VisualDensitySetting>(
          value: themeSettings.visualDensitySetting,
          items: [
            DropdownMenuItem<VisualDensitySetting>(
              value: VisualDensitySetting.standard(),
              child: const Text('Standard'),
            ),
            DropdownMenuItem<VisualDensitySetting>(
              value: VisualDensitySetting.compact(),
              child: const Text('Kompakt'),
            ),
            DropdownMenuItem<VisualDensitySetting>(
              value: VisualDensitySetting.comfortable(),
              child: const Text('Komfortabel'),
            ),
            DropdownMenuItem<VisualDensitySetting>(
              value: VisualDensitySetting.adaptivePlatformDensity(),
              child: const Text('Automatisch'),
            ),
          ],
          onChanged: (visualDensity) {
            themeSettings.visualDensitySetting = visualDensity!;
          },
        ),
      ],
    );
  }
}

class _DrawDebugThresholdIndicator extends StatelessWidget {
  const _DrawDebugThresholdIndicator({Key? key, required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    final drawIndicator = themeSettings.showDebugThresholdIndicator;
    return Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('"Am Lesen"-Indikator anzeigen',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 10),
          Checkbox(
            value: drawIndicator,
            onChanged: (newValue) {
              themeSettings.showDebugThresholdIndicator = newValue;
            },
          ),
        ]);
  }
}
