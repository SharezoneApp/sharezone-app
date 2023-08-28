// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// List which calls [onThresholdExceeded] when the [thresholdHeight] is
/// exceeded.
/// Is for example used for lazy loading lists.
class ListWithBottomThreshold extends StatefulWidget {
  /// Height in pixels marking an area that will call `onThresholdExceeded` when
  /// it gets into the view. The area sits at the bottom of the List and goes
  /// up.
  final double thresholdHeight;

  /// Callback which gets fired when `threshold` was surpassed by the bottom of
  /// the current view. If too few [children] are given so that the list can not
  /// scroll then the callback will not called. This should get fixed in the
  /// future
  /// (https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1069).
  final VoidCallback onThresholdExceeded;

  /// Shown at the bottom of the list when exceeding `threshold`.
  final Widget loadingIndicator;

  final int _nrOfChildren;

  /// The widgets which will be displayed in the list.
  final List<Widget> children;

  final EdgeInsetsGeometry padding;

  const ListWithBottomThreshold(
      {Key? key,
      this.thresholdHeight = 200.0,
      this.onThresholdExceeded = _doNothing,
      this.loadingIndicator = const _DefaultCircularLoadingIndicator(),
      this.children = const [],
      this.padding = const EdgeInsets.all(0)})
      : _nrOfChildren = children.length,
        super(key: key);

  @override
  _ListWithBottomThresholdState createState() =>
      _ListWithBottomThresholdState();
}

class _ListWithBottomThresholdState extends State<ListWithBottomThreshold> {
  final _controller = ScrollController(initialScrollOffset: 0.0);

  /// Whether to show `widget.loadingIndicator`.
  ///
  /// Defaults to true, so that the loading indicator shows on screen
  /// even if not enough elements are there to be able to scroll.
  bool loading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _onScroll);
  }

  @override
  void didUpdateWidget(ListWithBottomThreshold oldWidget) {
    // So when new data is passed the threshold is able to be called again. Can
    // not be in build() as this would lead to onThreshold being called several
    // times without new data.
    _wasCallbackCalled = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget._nrOfChildren < 0) {
      widget.onThresholdExceeded();
      return widget.loadingIndicator;
    }

    // Is used so that the _onScroll function is always at least called once,
    // because the ScrollController does not call its callback if there are too
    // few children in the ListView to be able to scroll.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Should only be called of the ScrollController did not call its callback.
      if (!_wasOnScrollCalled) {
        _onScroll();
      }
    });

    _controller.addListener(_onScroll);

    return Directionality(
      // Needed for ListView if no Ancestor with Directionality is given (mostly tests).
      textDirection: Directionality.of(context) ?? TextDirection.ltr,
      child: ListView(
        children: [...widget.children, if (loading) widget.loadingIndicator],
        controller: _controller,
        padding: widget.padding,
      ),
    );
  }

  // Is used for WidgetsBinding.instance.addPostFrameCallback
  bool _wasOnScrollCalled = false;
  bool _wasCallbackCalled = false;

  void _onScroll() {
    _wasOnScrollCalled = true;
    bool isOverThreshold =
        _controller.position.extentAfter < widget.thresholdHeight;
    if (isOverThreshold && !_wasCallbackCalled) {
      widget.onThresholdExceeded();
      _wasCallbackCalled = true;
      setState(() {
        loading = true;
      });
    } else if (!isOverThreshold && !_wasCallbackCalled) {
      setState(() {
        loading = false;
      });
    }
  }
}

void _doNothing() {}

class _DefaultCircularLoadingIndicator extends StatelessWidget {
  const _DefaultCircularLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Center(child: const AccentColorCircularProgressIndicator()),
    );
  }
}
