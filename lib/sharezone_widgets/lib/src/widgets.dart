// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

export 'prefilled_text_field.dart';
export 'widgets/modal_floating_action_button.dart';

Future<void> waitingForPopAnimation() async =>
    await Future.delayed(const Duration(milliseconds: 270));
Future<void> waitingForBottomModelSheetClosing() async =>
    await Future.delayed(const Duration(milliseconds: 100));

Future<void> closeKeyboardAndWait(BuildContext context) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await Future.delayed(const Duration(milliseconds: 150));
}

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
    this.size = 25,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const AccentColorCircularProgressIndicator(),
    );
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.padding,
    this.ignoreSameDateSelection = true,
  });

  final String? labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? selectDate;
  final EdgeInsets? padding;

  /// Whether to call [selectDate] if the chosen date equals [selectedDate].
  final bool ignoreSameDateSelection;

  Future<void> _selectDate(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final DateTime tomorrow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? tomorrow,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked == null) return;
    if (ignoreSameDateSelection && picked == selectedDate) return;
    selectDate!(picked);
  }

  @override
  Widget build(BuildContext context) {
    return _InputDropdown(
      iconData: Icons.today,
      labelText: labelText,
      valueText: selectedDate != null
          ? DateFormat('E, MMM d, yy').format(selectedDate!)
          : "Datum auswählen",
      padding: padding,
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus(); // Close keyboard
        await Future.delayed(
            const Duration(milliseconds: 150)); // Waiting for closing keyboard
        // ignore: use_build_context_synchronously
        _selectDate(context);
      },
    );
  }
}

class AccentColorCircularProgressIndicator extends StatelessWidget {
  const AccentColorCircularProgressIndicator(
      {super.key, this.value, this.strokeWidth = 4.0});

  final double? value, strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: accentColor)),
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth ?? 4,
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () => Navigator.pop(context),
      child: const Text("ABBRECHEN"),
    );
  }
}

class DeleteButtonWithPoppingTrue extends StatelessWidget {
  const DeleteButtonWithPoppingTrue({super.key, this.textColor});

  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? Colors.red,
      ),
      onPressed: () => Navigator.pop(context, true),
      child: const Text("LÖSCHEN"),
    );
  }
}

enum LogoColor {
  white,
  blueLong,
  blueShort,
}

class SharezoneLogo extends StatelessWidget {
  const SharezoneLogo({
    super.key,
    required this.logoColor,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;
  final LogoColor logoColor;

  String? getLogoPath() {
    switch (logoColor) {
      case LogoColor.blueLong:
        return "assets/logo/sharezone-logo-blue-long.svg";
      case LogoColor.blueShort:
        return "assets/logo/sharezone-logo-blue-short.svg";
      case LogoColor.white:
        return "assets/logo/sharezone-logo-white-long.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'sharezone-logo',
      child: PlatformSvg.asset(
        getLogoPath()!,
        height: height,
        width: width,
        semanticsLabel:
            'Logo von Sharezone: Ein blaues Heft-Icon mit einer Wolke, rechts daneben steht Sharezone.',
      ),
    );
  }
}

// Es darf entweder nur symbolText oder symbolIconData übergeben werden
class DialogTile extends StatelessWidget {
  const DialogTile({
    super.key,
    this.text,
    this.onPressed,
    this.symbolText,
    this.symbolIconData,
    this.enabled = true,
    this.trailing,
  });

  final String? symbolText;
  final IconData? symbolIconData;
  final bool enabled;
  final Widget? trailing;

//  final Color symbolIconColor;
  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: enabled ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          symbolText != null
              ? CircleAvatar(
                  backgroundColor:
                      enabled ? Theme.of(context).primaryColor : Colors.grey,
                  child: Text(symbolText!,
                      style: const TextStyle(color: Colors.white)),
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(symbolIconData,
                      color: Theme.of(context).primaryColor),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                text!,
                style: enabled ? null : TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
        ],
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    this.iconData,
    this.labelText,
    this.valueText,
    this.onPressed,
    this.padding,
  });

  final String? labelText;
  final String? valueText;

  final VoidCallback? onPressed;
  final IconData? iconData;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: focusBorderRadius,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    iconData,
                    color:
                        Theme.of(context).isDarkTheme ? null : Colors.grey[600],
                  ),
                  const SizedBox(width: 16),
                  labelText != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              labelText!,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(valueText!),
                          ],
                        )
                      : Text(
                          valueText!,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

// Zeigt einen AlterDialog an, der ein oder zwei Actions haben kann
// Vorteil ist, dass diese Variate Platz spart und übersichtlicher ist
void showAlert(
    {required BuildContext context,
    String? title,
    Widget? content,
    required String flatButton1Text,
    VoidCallback? flatButton1OnPressed,
    String? flatButton2Text,
    VoidCallback? flatButton2OnPressed}) {
  AlertDialog alert = AlertDialog(
    title: title != null ? Text(title) : null,
    content: content,
    actions: <Widget>[
      TextButton(
        onPressed: flatButton1OnPressed,
        child: Text(
          flatButton1Text.toUpperCase(),
          style: const TextStyle(color: Colors.lightBlue),
        ),
      ),
      flatButton2Text != null
          ? TextButton(
              onPressed: flatButton2OnPressed,
              child: Text(
                flatButton2Text.toUpperCase(),
                style: const TextStyle(color: Colors.lightBlue),
              ),
            )
          : Container(),
    ],
  );
  showDialog(context: context, builder: (BuildContext context) => alert);
}

// Eigene Karte, mit besserem Schatten und Ecken
class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.child,
    this.size,
    this.onTap,
    this.margin,
    this.opacity,
    this.padding = const EdgeInsets.all(0),
    this.blurRadius = 5,
    this.shadowColor = Colors.grey,
    this.offset = const Offset(0.0, 0.0),
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.onLongPress,
    this.withBorder = true,
    this.borderWidth = 1.5,
    super.key,
  });

  const CustomCard.roundVertical({
    required this.child,
    this.onTap,
    this.size,
    this.margin,
    this.opacity,
    this.padding = const EdgeInsets.all(0),
    this.blurRadius = 5,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(500), bottom: Radius.circular(500)),
    this.shadowColor = Colors.grey,
    this.offset = const Offset(0.0, 0.0),
    this.color,
    this.onLongPress,
    this.withBorder = false,
    this.borderWidth = 1,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Size? size;
  final Padding? margin;
  final double? opacity;
  final EdgeInsetsGeometry padding;
  final double blurRadius;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Color shadowColor;
  final Offset offset;
  final Color? color;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).cardColor;
    return SafeArea(
      left: true,
      right: true,
      bottom: false,
      top: false,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: margin as EdgeInsetsGeometry? ?? const EdgeInsets.all(0.0),
          child: Opacity(
            opacity: opacity ?? 1,
            child: Container(
              width: size?.height,
              height: size?.width,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
                border: withBorder
                    ? Border.all(
                        color: Theme.of(context).isDarkTheme
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        width: borderWidth)
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: borderRadius,
                  onTap: onTap,
                  onLongPress: onLongPress,
                  child: Padding(
                    padding: padding,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardListTile extends StatelessWidget {
  const CardListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.centerTitle = false,
    this.maxWidth = 550,
  });

  final Widget? leading, title, subtitle;
  final VoidCallback? onTap;
  final bool centerTitle;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;
    return MaxWidthConstraintBox(
      maxWidth: maxWidth,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CustomCard(
          onTap: onTap,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              if (hasLeading) ...[
                IconTheme(
                  data: Theme.of(context)
                      .iconTheme
                      .copyWith(color: Colors.grey[600]),
                  child: leading!,
                ),
                const SizedBox(width: 16)
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: rubik,
                          color: Theme.of(context).isDarkTheme
                              ? Colors.white
                              : Colors.black),
                      child: centerTitle
                          ? Padding(
                              padding:
                                  EdgeInsets.only(right: hasLeading ? 30 : 0),
                              child: Center(child: title),
                            )
                          : title!,
                    ),
                    if (subtitle != null)
                      DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.95),
                          fontSize: 12,
                          fontFamily: rubik,
                        ),
                        child: subtitle!,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpansionTileTitle extends StatelessWidget {
  const ExpansionTileTitle({
    super.key,
    required this.title,
    this.icon,
  });

  final String title;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon != null
            ? Row(
                children: <Widget>[
                  icon!,
                  const SizedBox(width: 16),
                ],
              )
            : Container(),
        Flexible(
            child: Text(
          title,
          style: TextStyle(
              color:
                  Theme.of(context).isDarkTheme ? Colors.white : Colors.black),
        )),
      ],
    );
  }
}

class ShowCenteredError extends StatelessWidget {
  const ShowCenteredError({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    log(error!);
    return const Center(
        child: Text(
            "Es gab leider einen Fehler beim Laden 😖\nVersuche es später einfach nochmal."));
  }
}

class LongPressDialogTile extends StatelessWidget {
  const LongPressDialogTile({super.key, this.title, this.iconData, this.onTap});

  final String? title;
  final IconData? iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(iconData),
      title: Text(title!),
      onTap: onTap,
    );
  }
}

class CloseIconButton extends StatelessWidget {
  const CloseIconButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Schließen',
      icon: const Icon(Icons.close),
      color: color ?? Theme.of(context).appBarTheme.iconTheme!.color,
      onPressed: () => Navigator.pop(context),
    );
  }
}

class InformationDialog extends StatelessWidget {
  const InformationDialog({
    super.key,
    this.title,
    required this.text,
    this.actionText,
    this.closeOnTap = true,
  });

  final String? title, text, actionText;
  final bool closeOnTap;

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      child: GestureDetector(
        onTap: () {
          if (closeOnTap) {
            Navigator.pop(context);
          }
        },
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: !isEmptyOrNull(title) ? Text(title!) : null,
          content: Text(text!),
          actions: !isEmptyOrNull(actionText)
              ? <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(actionText!),
                  )
                ]
              : null,
        ),
      ),
    );
  }
}

class BottomSheetSlider extends StatelessWidget {
  const BottomSheetSlider(
      {super.key,
      this.padding = const EdgeInsets.only(top: 8),
      this.width = 55});

  final EdgeInsets padding;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: padding,
        child: Container(
          width: width,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[400]!.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}

class TextFieldWithDescription extends StatelessWidget {
  const TextFieldWithDescription({super.key, this.textField, this.description});

  final Widget? textField;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        textField!,
        const SizedBox(height: 8),
        Text(description!,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

Future<bool> warnUserAboutLeavingForm(BuildContext context) async {
  await closeKeyboardAndWait(context);
  // ignore: use_build_context_synchronously
  return await showLeftRightAdaptiveDialog<bool>(
        context: context,
        title: 'Eingabe verlassen?',
        content: const Text(
            'Möchtest du die Eingabe wirklich beenden? Die Daten werden nicht gespeichert!'),
        defaultValue: false,
        right: const AdaptiveDialogAction(
          title: "Verlassen",
          isDefaultAction: true,
          popResult: true,
        ),
      ) ??
      false;
}

Future<bool> warnUserAboutLeavingOrSavingForm(
    BuildContext context, VoidCallback onSave) async {
  await closeKeyboardAndWait(context);
  // ignore: use_build_context_synchronously
  final result = await showLeftRightAdaptiveDialog<bool>(
    title: 'Verlassen oder Speichern?',
    defaultValue: null,
    content: const Text(
        'Möchtest du die Eingabe verlassen oder speichern? Verlässt du die Eingabe, werden die Daten nicht gespeichert'),
    context: context,
    withCancelButtonOnIOS: true,
    left: const AdaptiveDialogAction(
      title: "Verlassen",
      popResult: false,
    ),
    right: const AdaptiveDialogAction(
      title: "Speichern",
      popResult: true,
    ),
  );

  if (result == null) {
    return false;
  } else if (result) {
    onSave();
    return false;
  }
  return true;
}

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;

  const CircleCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  }) : assert(tristate);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(unselectedWidgetColor: const Color(0xFF757575)),
      child: ClipOval(
        child: SizedBox(
          width: Checkbox.width,
          height: Checkbox.width,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.225,
                color: const Color(0xFF757575).withOpacity(1),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Checkbox(
              value: value,
              tristate: tristate,
              onChanged: onChanged,
              activeColor: activeColor,
              checkColor: checkColor,
              materialTapTargetSize: materialTapTargetSize,
            ),
          ),
        ),
      ),
    );
  }
}

class DestroyButton extends StatelessWidget {
  final Color color;
  final Text title;
  final VoidCallback? onTap;
  final Widget? icon;

  const DestroyButton({
    super.key,
    this.color = Colors.redAccent,
    required this.title,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomCard(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        onTap: onTap,
        color: color,
        withBorder: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) icon!,
            Padding(
              padding: const EdgeInsets.all(10),
              child: DefaultTextStyle(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                child: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: MediaQuery.of(context).size.height - 100,
      color: Colors.grey[200],
    );
  }
}

class CustomCardListTile extends StatelessWidget {
  const CustomCardListTile(
      {super.key, this.onTap, this.icon, required this.title, this.subtitle});

  final VoidCallback? onTap;
  final Widget? icon;
  final String? title, subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            icon!,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  if (isNotEmptyOrNull(subtitle)) ...[
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText(
      {super.key, required this.text, this.fontSize = 14, this.textStyle});

  final String text;
  final double fontSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(width: 200),
      const Padding(
          padding: EdgeInsets.only(top: 8), child: Divider(height: 0)),
      Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(text,
                style: TextStyle(
                    color: Theme.of(context).isDarkTheme
                        ? Colors.grey[400]
                        : Colors.grey[600],
                    fontSize: fontSize)),
          ),
        ),
      ),
    ]);
  }
}
