// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0).toDouble();

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

/// Displays a row of small circular indicators, one per tab. The selected
/// tab's indicator is highlighted. Often used in conjunction with a [TabBarView].
///
/// If a [TabController] is not provided, then there must be a [DefaultTabController]
/// ancestor.
class SharezoneTabPageSelector extends StatelessWidget {
  /// Creates a compact widget that indicates which tab has been selected.
  const SharezoneTabPageSelector({
    Key key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
    this.withBorder,
  })  : assert(indicatorSize != null && indicatorSize > 0.0),
        super(key: key);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController controller;

  /// The indicator circle's diameter (the default value is 12.0).
  final double indicatorSize;

  /// The indicator circle's fill color for unselected pages.
  ///
  /// If this parameter is null then the indicator is filled with [Colors.transparent].
  final Color color;

  /// The indicator circle's fill color for selected pages and border color
  /// for all indicator circles.
  ///
  /// If this parameter is null then the indicator is filled with the theme's
  /// accent color, [ThemeData.colorScheme.secondary].
  final Color selectedColor;

  /// The indicator circle's fill the border for all circles
  final bool withBorder;

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    Color background;
    if (tabController.indexIsChanging) {
      // The selection's animation is animating from previousValue to value.
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex)
        background = selectedColorTween.lerp(t);
      else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t);
      else
        background = selectedColorTween.begin;
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs());
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset);
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset);
      } else {
        background = selectedColorTween.begin;
      }
    }
    return _TabPageSelectorIndicator(
      backgroundColor: background,
      borderColor:
          withBorder != null && withBorder ? selectedColorTween.end : null,
      size: indicatorSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor =
        selectedColor ?? Theme.of(context).colorScheme.secondary;
    final ColorTween selectedColorTween =
        ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween =
        ColorTween(begin: fixSelectedColor, end: fixColor);
    final TabController tabController =
        controller ?? DefaultTabController.of(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError('No TabController for $runtimeType.\n'
            'When creating a $runtimeType, you must either provide an explicit TabController '
            'using the "controller" property, or you must ensure that there is a '
            'DefaultTabController above the $runtimeType.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController.animation,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Semantics(
            label: 'Page ${tabController.index + 1} of ${tabController.length}',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:
                  List<Widget>.generate(tabController.length, (int tabIndex) {
                return _buildTabIndicator(tabIndex, tabController,
                    selectedColorTween, previousColorTween);
              }).toList(),
            ),
          );
        });
  }
}

/// Displays a single circle with the specified border and background colors.
///
/// Used by [TabPageSelector] to indicate the selected page.
class _TabPageSelectorIndicator extends StatelessWidget {
  /// Creates an indicator used by [TabPageSelector].
  ///
  /// The [backgroundColor], [borderColor], and [size] parameters must not be null.
  const _TabPageSelectorIndicator({
    Key key,
    @required this.backgroundColor,
    this.borderColor,
    @required this.size,
  })  : assert(backgroundColor != null),
        assert(size != null),
        super(key: key);

  /// The indicator circle's background color.
  final Color backgroundColor;

  /// The indicator circle's border color.
  final Color borderColor;

  /// The indicator circle's diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor) : null,
        shape: BoxShape.circle,
      ),
    );
  }
}
