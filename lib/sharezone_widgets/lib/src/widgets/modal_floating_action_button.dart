// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ModalFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color? backgroundColor;
  final String tooltip;
  final String? heroTag;
  final String? label;

  const ModalFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    required this.tooltip,
    this.label,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    return Semantics(
      label: tooltip,
      button: true,
      child: dimensions.isDesktopModus
          ? FloatingActionButton.extended(
              backgroundColor: backgroundColor,
              label: Text(label ?? tooltip),
              icon: icon,
              onPressed: onPressed,
              heroTag: heroTag,
            )
          : FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: backgroundColor,
              heroTag: heroTag,
              tooltip: tooltip,
              child: icon,
            ),
    );
  }
}
