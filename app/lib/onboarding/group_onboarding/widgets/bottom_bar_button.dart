// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: onTap,
        child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
