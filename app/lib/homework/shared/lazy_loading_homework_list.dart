import 'package:flutter/material.dart';
import 'package:sharezone/homework/shared/glowing_overscroll_color_changer.dart';
import 'package:sharezone/homework/shared/shared.dart';
import 'package:sharezone/pages/settings/changelog/list_with_bottom_threshold.dart';
import 'package:sharezone_widgets/widgets.dart';

/// A list to lazily load homeworks.
/// Basically a [ListWithBottomThreshold] with some defaults for homeworks.
class LazyLoadingHomeworkList extends StatelessWidget {
  /// The homework cards / tiles that should be shown in the list.
  final List<Widget> children;

  /// If all homeworks that are available from the backend have been loaded.
  /// If this is `false` the [LazyLoadingHomeworkList] will show the
  /// [infiniteScrollLoadingIndicator] at the bottom of the list.
  final bool loadedAllHomeworks;

  /// The color to overrite the default [GlowingOverscrollIndicator] of the list
  /// view.
  final Color overscrollColor;

  /// The loading indicator shown at the end of the list.
  /// Is not shown if [homeworkListView.loadedAllHomeworks] is true
  final Widget infiniteScrollLoadingIndicator;

  /// Callback that indicates that the client should load more homework.
  /// Called when the user is near the end of the homework list.
  final VoidCallback loadMoreHomeworksCallback;
  static const double threshold = 200.0;

  const LazyLoadingHomeworkList({
    Key key,
    @required this.children,
    @required this.loadedAllHomeworks,
    @required this.loadMoreHomeworksCallback,
    // Same as Colors.grey[600] which can't be used because it's not const.
    this.overscrollColor = const Color(0xFF757575),
    this.infiniteScrollLoadingIndicator =
        const _LazyLoadingHomeworkListLoadingIndicator(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noHomeworks = children.isEmpty && loadedAllHomeworks;

    if (noHomeworks) return Container();
    return GlowingOverscrollColorChanger(
      color: overscrollColor,
      child: ListWithBottomThreshold(
        loadingIndicator: loadedAllHomeworks
            ? Container()
            : _LazyLoadingHomeworkListLoadingIndicator(),
        onThresholdExceeded: loadMoreHomeworksCallback ?? () {},
        thresholdHeight: threshold,
        children: children,
      ),
    );
  }
}

class _LazyLoadingHomeworkListLoadingIndicator extends StatelessWidget {
  const _LazyLoadingHomeworkListLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Center(child: AccentColorCircularProgressIndicator()),
    );
  }
}
