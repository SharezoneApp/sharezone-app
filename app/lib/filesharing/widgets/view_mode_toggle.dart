// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class ViewModeToggle extends StatefulWidget {
  const ViewModeToggle({
    super.key,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  final FileSharingViewMode viewMode;
  final ValueChanged<FileSharingViewMode> onViewModeChanged;

  @override
  State<ViewModeToggle> createState() => _ViewModeToggleState();
}

class _ViewModeToggleState extends State<ViewModeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    _setInitialAnimatedIconPosition();
  }

  void _setInitialAnimatedIconPosition() {
    controller.value = switch (widget.viewMode) {
      FileSharingViewMode.list => 0.0,
      FileSharingViewMode.grid => 1.0,
    };
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: switch (widget.viewMode) {
        FileSharingViewMode.list => context.l10n.calendricalEventsSwitchToGrid,
        FileSharingViewMode.grid => context.l10n.calendricalEventsSwitchToList,
      },
      onPressed: () {
        widget.onViewModeChanged(switch (widget.viewMode) {
          FileSharingViewMode.list => FileSharingViewMode.grid,
          FileSharingViewMode.grid => FileSharingViewMode.list,
        });
        controller.fling(
          velocity: switch (widget.viewMode) {
            FileSharingViewMode.list => 1.0,
            FileSharingViewMode.grid => -1.0,
          },
        );
      },
      icon: AnimatedIcon(icon: AnimatedIcons.view_list, progress: animation),
    );
  }
}
