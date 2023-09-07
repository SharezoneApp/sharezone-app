// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// A widget to control the visibility of a [child] widget in different tabs of
/// a [TabController].
///
/// Can be used to show a widget only in one [TabBarView] of a [TabBar].
/// ```dart
/// class _MyExample extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return SelectedTabsVisibility(
///       visibleInTabIndicies: const [0,1],
///       child: Text('Only visible if one of the first two tabs is selected.')
///     );
///   }
/// }
/// ```
/// In the example above the [Text] would be only visible if the first or second
/// (index `0` and `1`) tab would be selected.
/// As no `SelectedTabsVisibility.tabController` is given the
/// `DefaultTabController` from the [BuildContext] is used.
///
/// Sharezone uses this currently to show a bottom bar (for sorting homeworks)
/// only on the uncompleted homeworks page but not on the completed homeworks
/// page (as the sorting functionality is not currently implemented for all
/// completed homeworks).
///
/// If no [tabController] is given the [DefaultTabController] of the current
/// [BuildContext] is used.
class AnimatedTabVisibility extends StatefulWidget {
  /// The widget which should be hidden if [tabController.index] is not one of
  /// [visibleInTabIndicies].
  final Widget child;

  /// Controls in which tabs of the [tabController] the [child] is visible.
  /// The tabs are referenced by their index. E.g. `0` is the first tab, `1` the
  /// second and so forth. `visibleInTabIndicies = [0,2]` means that the widget [child]
  /// is shown in the first and third tab.
  ///
  /// Example:
  /// If [visibleInTabIndicies] is `[0,1]` and [tabController.index] is `0` then
  /// the [child] is visible.
  /// If the [tabController] then changes the [tabController.index] to `2` then
  /// the [child] will be animated to be invisible.
  final List<int> visibleInTabIndicies;

  /// The [TabController] which is used to see if the [TabController.index] is
  /// one of [visibleInTabIndicies].
  /// If [tabController] is `null` [AnimatedTabVisibility] will use the
  /// `DefaultTabController.of(context)` or throw if neither is available.
  final TabController? tabController;

  /// Whether to maintain the [State] objects of the [child] subtree when it is
  /// not visible.
  final bool maintainState;

  /// The curve to apply when animating the the fade-in/fade-out of the [child].
  final Curve curve;

  /// Called every time the fade-in/fade-out animation completes.
  ///
  /// This can be useful to trigger additional actions (e.g. another animation)
  /// at the end of the current animation.
  final VoidCallback? onEnd;

  const AnimatedTabVisibility({
    Key? key,
    required this.child,
    required this.visibleInTabIndicies,
    this.tabController,
    // Same default as [Visiblity.maintainState]
    this.maintainState = false,
    this.curve = Curves.linear,
    this.onEnd,
  }) : super(key: key);

  @override
  _AnimatedTabVisibilityState createState() => _AnimatedTabVisibilityState();
}

class _AnimatedTabVisibilityState extends State<AnimatedTabVisibility> {
  bool? isVisible;
  TabController? tabController;

  /// [true] if the [build] function has not been run yet.
  late bool isFirstBuild;

  @override
  void initState() {
    isVisible = false;
    isFirstBuild = true;
    tabController = widget.tabController;
    super.initState();
  }

  bool _shouldChildBeVisible() {
    return widget.visibleInTabIndicies.contains(tabController!.index);
  }

  void _animateVisibilityIfNecessary() {
    final shouldBeVisible = _shouldChildBeVisible();
    if (shouldBeVisible != isVisible) {
      setState(() {
        isVisible = shouldBeVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    tabController ??= DefaultTabController.of(context);
    tabController!.addListener(() {
      _animateVisibilityIfNecessary();
    });

    /// As [tabController.addListener] won't be triggerd on the first build
    /// but only when the index changes, we check it here one time manually.
    /// [isFirstBuild] is used so that when `setState` is called by
    /// [tabController.addListener] we don't call `setState` again.
    if (isFirstBuild) {
      isFirstBuild = false;
      _animateVisibilityIfNecessary();
    }

    return AnimatedVisibility(
      child: widget.child,
      visible: isVisible!,
      maintainState: widget.maintainState,
      duration: Duration(milliseconds: 300),
      curve: widget.curve,
      onEnd: widget.onEnd,
    );
  }
}
