// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CallToActionButton extends StatelessWidget {
  const CallToActionButton({
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
  }) : super(key: const ValueKey('call-to-action-button'));

  final Widget text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 350,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.5),
              side: BorderSide(color: borderColor),
            ),
            foregroundColor: textColor,
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: text,
          ),
        ),
      ),
    );
  }
}
