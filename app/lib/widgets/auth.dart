// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

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
