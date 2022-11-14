// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';
import 'package:sharezone_widgets/theme.dart';

class DisplaySettingsDialog extends StatelessWidget {
  const DisplaySettingsDialog({Key key, @required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    // Our Dialog does not use the same context as the privacy policy page so we
    // must manually apply our theme settings here again.
    return AnimatedBuilder(
      animation: themeSettings,
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: themeSettings.textScalingFactor,
        ),
        child: Theme(
          data: ThemeData(
              brightness:
                  _getBrightness(context, themeSettings.themeBrightness)),
          child: SimpleDialog(
            title: Text('Anzeigeeinstellungen'),
            children: [
              _TextSize(themeSettings: themeSettings),
              SizedBox(height: 20),
              _LightOrDarkMode(themeSettings: themeSettings),
              SizedBox(height: 10),
              _VisualDensity(themeSettings: themeSettings),
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
  const _TextSize({Key key, @required this.themeSettings}) : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Textskalierungsfaktor',
              style: Theme.of(context).textTheme.button),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.bodyMedium.color,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    themeSettings.textScalingFactor =
                        (themeSettings.textScalingFactor * 10 - 0.1 * 10) / 10;
                  },
                ),
                Text('${themeSettings.textScalingFactor}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    themeSettings.textScalingFactor =
                        (themeSettings.textScalingFactor * 10 + 0.1 * 10) / 10;
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
  const _LightOrDarkMode({Key key, @required this.themeSettings})
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
          Text('Dunkel-/Hellmodus', style: Theme.of(context).textTheme.button),
          SizedBox(width: 10),
          Column(
            children: [
              ToggleButtons(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                selectedColor: isDarkThemeEnabled(context)
                    ? Colors.black.withAlpha(240)
                    : null, // standard color
                fillColor: isDarkThemeEnabled(context)
                    ? blueColor
                    : null, // standard color
                borderColor: Theme.of(context).textTheme.bodyMedium.color,
                selectedBorderColor:
                    Theme.of(context).textTheme.bodyMedium.color,
                children: const [
                  Icon(Icons.dark_mode),
                  Icon(Icons.light_mode),
                  Icon(Icons.settings_brightness),
                ],
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
                  }[index];

                  themeSettings.themeBrightness = brightness;
                },
              ),
              Text(_getText())
            ],
          ),
        ],
      ),
    );
  }

  String _getText() {
    return <ThemeBrightness, String>{
      ThemeBrightness.dark: 'Dunkler Modus',
      ThemeBrightness.light: 'Heller Modus',
      ThemeBrightness.system: 'Automatisch',
    }[themeSettings.themeBrightness];
  }
}

class _VisualDensity extends StatelessWidget {
  const _VisualDensity({Key key, @required this.themeSettings})
      : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Visuelle Kompaktheit', style: Theme.of(context).textTheme.button),
        SizedBox(width: 10),
        DropdownButton<VisualDensitySetting>(
          value: themeSettings.visualDensitySetting,
          items: [
            DropdownMenuItem(
              child: Text('Kompakt'),
              value: VisualDensitySetting.manual(VisualDensity.compact),
            ),
            DropdownMenuItem(
              child: Text('Komfortabel'),
              value: VisualDensitySetting.manual(VisualDensity.comfortable),
            ),
            DropdownMenuItem(
              child: Text('Automatisch'),
              value: VisualDensitySetting.adaptivePlatformDensity(),
            ),
          ],
          onChanged: (visualDensity) {
            themeSettings.visualDensitySetting = visualDensity;
          },
        ),
      ],
    );
  }
}
