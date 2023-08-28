// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ModalBottomSheetBigIconButton<T> extends StatelessWidget {
  const ModalBottomSheetBigIconButton({
    Key? key,
    required this.title,
    required this.iconData,
    required this.popValue,
    required this.tooltip,
    this.alignment = Alignment.center,
    this.onTap,
  }) : super(key: key);

  final String title, tooltip;
  final IconData iconData;
  final Alignment alignment;

  /// The value, which will be returned by poping (Navigator.pop)
  final T popValue;

  // onTap wird höher als popValue gewichtet
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(75)),
            onTap: onTap ?? () => Navigator.pop(context, popValue),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 1.25),
                    ),
                    child: Icon(
                      iconData,
                      size: 40,
                      color: isDarkThemeEnabled(context)
                          ? Colors.white70
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkThemeEnabled(context)
                          ? Colors.white70
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
