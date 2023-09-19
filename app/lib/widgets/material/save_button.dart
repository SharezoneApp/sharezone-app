// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    this.onPressed,
    this.tooltip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          foregroundColor: Theme.of(context).isDarkTheme
              ? null
              : Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.transparent,
        ),
        child: const Text('Speichern'),
      ),
    );
  }
}
