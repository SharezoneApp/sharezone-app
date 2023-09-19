// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef IsAtEdge = void Function(bool isAtEdge);

/// Hides [child] if the connected scrollable widget is near it's lower edge.
/// For example it is used to hide a FAB lying on a List as it may hide widgets
/// beneath.
///
/// To use it you need to:
///
/// * Provide a [BottomOfScrollViewInvisibilityController] above the
///   [BottomOfScrollViewInvisibility] and [ScrollView].
///
///   This uses the provider package for passing widgets down the widget
///   tree. It uses the [ChangeNotifierProvider].
///   ```
///   ChangeNotifierProvider<BottomOfScrollViewInvisibilityController>(
///      create: (_) => BottomOfScrollViewInvisibilityController(),
///      child: Scaffold(
///         // ....
///      ),
///   );
///   ```
///
/// * Wrap the widget to hide inside this [BottomOfScrollViewInvisibility].
///
///   ```
///   Scaffold(
///     // ....
///     floatingActionButton:
///         BottomOfScrollViewInvisibility(child: HomeworkFab()),
///   )
///   ```
///
/// * Register the [ScrollController] on the
///   [BottomOfScrollViewInvisibilityController].
///
///   ```
///   Widget build(BuildContext context) {
///     final scrollController = ScrollController();
///     Provider.of<BottomOfScrollViewInvisibilityController>(context)
///         .registeredScrollController = scrollController;
///
///     return SingleChildScrollView(
///       controller: scrollController,
///       child: // ....
///     );
///   }
///   ```
class BottomOfScrollViewInvisibility extends StatefulWidget {
  final Widget child;

  const BottomOfScrollViewInvisibility({Key? key, required this.child})
      : super(key: key);

  @override
  State createState() => _BottomOfScrollViewInvisibilityState();
}

class _BottomOfScrollViewInvisibilityState
    extends State<BottomOfScrollViewInvisibility> {
  @override
  Widget build(BuildContext context) {
    final isAtEdgeController =
        Provider.of<BottomOfScrollViewInvisibilityController>(context);

    return Visibility(
      visible: !isAtEdgeController.isInBottomZone,
      child: widget.child,
    );
  }
}

/// Controls the visibility of [BottomOfScrollViewInvisibility] by looking
/// if the [registeredScrollController] is near the bottom of its max extent.
/// This "zone" is controlled by the [heightOfBottomZoneInPixel].
///
/// To see how it is used in conjunction with [BottomOfScrollViewInvisibility]
/// see the documentation of [BottomOfScrollViewInvisibility].
class BottomOfScrollViewInvisibilityController extends ChangeNotifier {
  BottomOfScrollViewInvisibilityController(
      {this.heightOfBottomZoneInPixel = 20});

  /// The size of the bottom zone of the [ScrollPosition] where the FAB will be
  /// hidden.
  ///
  /// If it is e.g. 20 pixels then the last 20 pixels before and including the max
  /// extent will hide the FAB.
  final double heightOfBottomZoneInPixel;

  /// If the [registeredScrollController.position] is in the bottom zone.
  /// This will cause the [BottomOfScrollViewInvisibility] to hide it's child.
  bool get isInBottomZone => _isAtBottomZone;
  bool _isAtBottomZone = false;

  /// The [ScrollController] which is observed.
  /// This should be the [ScrollController] which is passed to the [ScrollView]
  /// used by the user.
  ScrollController? get registeredScrollController =>
      _registeredScrollController;
  set registeredScrollController(ScrollController? registeredScrollController) {
    _registeredScrollController = registeredScrollController;
    _listenToScrollController(registeredScrollController);
  }

  ScrollController? _registeredScrollController;

  void _listenToScrollController(ScrollController? registeredScrollController) {
    _registeredScrollController!.addListener(() {
      final position = registeredScrollController!.position;

      final lowerEdgeStart =
          position.maxScrollExtent - heightOfBottomZoneInPixel;
      final lowerEdgeEnd = position.maxScrollExtent;

      final before = isInBottomZone;
      _isAtBottomZone =
          lowerEdgeStart <= position.pixels && position.pixels <= lowerEdgeEnd;

      if (before != _isAtBottomZone) notifyListeners();
    });
  }
}
