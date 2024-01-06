// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class ContinueRoundButton extends StatelessWidget {
  const ContinueRoundButton({
    super.key,
    required this.onTap,
    this.tooltip,
  });

  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      onTap: onTap,
      label: tooltip,
      child: IconButton(
        tooltip: tooltip,
        icon: Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: 35,
                key: ValueKey('ContinueRoundButton: ${onTap == null}'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: onTap == null
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.chevron_right, color: Colors.white),
            )
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}
