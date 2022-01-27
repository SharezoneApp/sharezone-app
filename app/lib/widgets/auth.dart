// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/svg.dart';
import 'package:sharezone_widgets/theme.dart';

// Logo Widget - Rundes Sharezone Logo
class LogoRound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo-round',
      child: PlatformSvg.asset(
        "assets/logo-round",
        width: 160,
        height: 160,
      ),
    );
  }
}

// Basic Widget for Login & Register
class NextContractor extends StatelessWidget {
  const NextContractor({this.children, this.alignment = Alignment.center});

  final List<Widget> children;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme,
      child: Container(
        // Background
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaper/auth/next.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: alignment,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
          child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children),
          ),
        ),
      ),
    );
  }
}

// Button zum Abschicken der Login-Daten, Registierungs-Daten
// und der E-Mail bei Passwort vergessen
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    @required this.titel,
    @required this.onPressed,
    this.padding,
    this.color = Colors.white,
    this.textColor = Colors.lightBlueAccent,
  });

  final String titel;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding == null ? const EdgeInsets.symmetric(vertical: 0.0) : padding,
      child: SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(primary: color),
          child: Text(
            titel.toUpperCase(),
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
