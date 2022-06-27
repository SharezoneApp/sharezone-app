import 'package:flutter/material.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';

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
              brightness: _getBrightness(themeSettings.themeBrightness)),
          child: SimpleDialog(
            title: Text('Anzeigeeinstellungen'),
            children: [
              _TextSize(themeSettings: themeSettings),
              SizedBox(height: 20),
              _LightOrDarkMode(themeSettings: themeSettings),
            ],
          ),
        ),
      ),
    );
  }
}

Brightness _getBrightness(ThemeBrightness themeBrightness) {
  switch (themeBrightness) {
    case ThemeBrightness.dark:
      return Brightness.dark;
    case ThemeBrightness.light:
      return Brightness.light;
    default:
  }
  return null;
}

class _TextSize extends StatefulWidget {
  const _TextSize({
    Key key,
    this.themeSettings,
  }) : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  State<_TextSize> createState() => _TextSizeState();
}

class _TextSizeState extends State<_TextSize> {
  @override
  Widget build(BuildContext context) {
    final themeSettings = widget.themeSettings;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Schriftgröße', style: Theme.of(context).textTheme.button),
          // SizedBox(width: 20),
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

                    setState(() {});
                  },
                ),
                Text('${themeSettings.textScalingFactor}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    themeSettings.textScalingFactor =
                        (themeSettings.textScalingFactor * 10 + 0.1 * 10) / 10;

                    setState(() {});
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

class _LightOrDarkMode extends StatefulWidget {
  const _LightOrDarkMode({
    Key key,
    this.themeSettings,
  }) : super(key: key);

  final PrivacyPolicyThemeSettings themeSettings;

  @override
  State<_LightOrDarkMode> createState() => _LightOrDarkModeState();
}

class _LightOrDarkModeState extends State<_LightOrDarkMode> {
  @override
  Widget build(BuildContext context) {
    final themeSettings = widget.themeSettings;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Dunkel-/Hellmodus', style: Theme.of(context).textTheme.button),
        SizedBox(width: 20),
        ToggleButtons(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderColor: Theme.of(context).textTheme.bodyMedium.color,
          children: [
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
            setState(() {});
          },
        ),
      ],
    );
  }
}
