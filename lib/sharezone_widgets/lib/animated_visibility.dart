// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

/// A widget to show/hide a [child] with a fade-in/fade-out.
///
/// Difference to:
/// * [Visibility] - hides only a [child] without an animation.
/// * [AnimatedOpacity] - only makes [child] transparent (can still be
///   interacted with)
/// * [AnimatedSwitcher] - can be used to hide/show children with a fade but
///   does not have the customizability of the [maintain...] parameters.
///
/// By default, the [visible] property controls whether the [child] is included
/// in the subtree or not; when it is not [visible], the [replacement] child
/// (typically a zero-sized box) is included instead.
///
/// A variety of flags can be used to tweak exactly how the child is hidden.
/// (Changing the flags dynamically is discouraged, as it can cause the [child]
/// subtree to be rebuilt, with any state in the subtree being discarded.
/// Typically, only the [visible] flag is changed dynamically.)
///
/// These widgets provide some of the facets of this one:
///
///  * [Opacity], which can stop its child from being painted.
///  * [Offstage], which can stop its child from being laid out or painted.
///  * [TickerMode], which can stop its child from being animated.
///  * [ExcludeSemantics], which can hide the child from accessibility tools.
///  * [IgnorePointer], which can disable touch interactions with the child.
///
/// Using this widget is not necessary to hide children. The simplest way to
/// hide a child is just to not include it, or, if a child _must_ be given (e.g.
/// because the parent is a [StatelessWidget]) then to use [SizedBox.shrink]
/// instead of the child that would otherwise be included.
///
/// See also:
///
///  * [AnimatedSwitcher], which can fade from one child to the next as the
///    subtree changes.
///  * [AnimatedCrossFade], which can fade between two specific children.
class AnimatedVisibility extends StatefulWidget {
  /// The widget which should be hidden if [tabController.index] is not one of
  /// [visibleInTabIndicies].
  final Widget child;

  /// Animates between showing or hiding the [child].
  ///
  /// If this values changes from false to true the [child] will fade-in.
  /// If this values changes from true to false the child will fade-out.
  ///
  /// (Copied from [Visibility]):
  /// The `maintain` flags should be set to the same values regardless of the
  /// state of the [visible] property, otherwise they will not operate correctly
  /// (specifically, the state will be lost regardless of the state of
  /// [maintainState] whenever any of the `maintain` flags are changed, since
  /// doing so will result in a subtree shape change).
  ///
  /// Unless [maintainState] is set, the [child] subtree will be disposed
  /// (removed from the tree) while hidden.
  final bool visible;

  /// The duration over which to animate the fade-in/fade-out of the [child].
  final Duration duration;

  /// The widget to use when the child is not [visible], assuming that none of
  /// the `maintain` flags (in particular, [maintainState]) are set.
  ///
  /// The normal behavior is to replace the widget with a zero by zero box
  /// ([SizedBox.shrink]).
  ///
  /// See also:
  ///
  ///  * [AnimatedCrossFade], which can animate between two children.
  final Widget replacement;

  /// Whether to maintain the [State] objects of the [child] subtree when it is
  /// not [visible].
  ///
  /// Keeping the state of the subtree is potentially expensive (because it
  /// means all the objects are still in memory; their resources are not
  /// released). It should only be maintained if it cannot be recreated on
  /// demand. One example of when the state would be maintained is if the child
  /// subtree contains a [Navigator], since that widget maintains elaborate
  /// state that cannot be recreated on the fly.
  ///
  /// If this property is true, an [Offstage] widget is used to hide the child
  /// instead of replacing it with [replacement].
  ///
  /// If this property is false, then [maintainAnimation] must also be false.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  final bool maintainState;

  /// Whether to maintain animations within the [child] subtree when it is
  /// not [visible].
  ///
  /// To set this, [maintainState] must also be set.
  ///
  /// Keeping animations active when the widget is not visible is even more
  /// expensive than only maintaining the state.
  ///
  /// One example when this might be useful is if the subtree is animating its
  /// layout in time with an [AnimationController], and the result of that
  /// layout is being used to influence some other logic. If this flag is false,
  /// then any [AnimationController]s hosted inside the [child] subtree will be
  /// muted while the [visible] flag is false.
  ///
  /// If this property is true, no [TickerMode] widget is used.
  ///
  /// If this property is false, then [maintainSize] must also be false.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  final bool maintainAnimation;

  /// Whether to maintain space for where the widget would have been.
  ///
  /// To set this, [maintainAnimation] and [maintainState] must also be set.
  ///
  /// Maintaining the size when the widget is not [visible] is not notably more
  /// expensive than just keeping animations running without maintaining the
  /// size, and may in some circumstances be slightly cheaper if the subtree is
  /// simple and the [visible] property is frequently toggled, since it avoids
  /// triggering a layout change when the [visible] property is toggled. If the
  /// [child] subtree is not trivial then it is significantly cheaper to not
  /// even keep the state (see [maintainState]).
  ///
  /// If this property is true, [Opacity] is used instead of [Offstage].
  ///
  /// If this property is false, then [maintainSemantics] and
  /// [maintainInteractivity] must also be false.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  ///
  /// See also:
  ///
  ///  * [AnimatedOpacity] and [FadeTransition], which apply animations to the
  ///    opacity for a more subtle effect.
  final bool maintainSize;

  /// Whether to maintain the semantics for the widget when it is hidden (e.g.
  /// for accessibility).
  ///
  /// To set this, [maintainSize] must also be set.
  ///
  /// By default, with [maintainSemantics] set to false, the [child] is not
  /// visible to accessibility tools when it is hidden from the user. If this
  /// flag is set to true, then accessibility tools will report the widget as if
  /// it was present.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  final bool maintainSemantics;

  /// Whether to allow the widget to be interactive when hidden.
  ///
  /// To set this, [maintainSize] must also be set.
  ///
  /// By default, with [maintainInteractivity] set to false, touch events cannot
  /// reach the [child] when it is hidden from the user. If this flag is set to
  /// true, then touch events will nonetheless be passed through.
  ///
  /// Dynamically changing this value may cause the current state of the
  /// subtree to be lost (and a new instance of the subtree, with new [State]
  /// objects, to be immediately created if [visible] is true).
  final bool maintainInteractivity;

  /// The curve to apply when animating the the fade-in/fade-out of the [child].
  final Curve curve;

  /// Called every time the fade-in/fade-out animation completes.
  ///
  /// This can be useful to trigger additional actions (e.g. another animation)
  /// at the end of the current animation.
  final VoidCallback onEnd;

  const AnimatedVisibility({
    Key key,
    @required this.child,
    @required this.duration,
    this.visible = true,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
    this.curve = Curves.linear,
    this.onEnd,
    this.replacement = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  _AnimatedVisibilityState createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility> {
  /// Controls [AnimatedOpacity.opacity].
  /// If [isTransparent] is true [AnimatedOpacity.opacity] will be 1.
  /// This means it will fade-in the [child].
  /// The opposite happens when [isTransparent] is false ([child] fades-out).
  ///
  /// To better understand the difference to [isVisible] see the comment
  /// in the [build] method.
  bool isTransparent;

  /// Controls [Visibility.visible].
  /// If [isVisible] is `true` the child will be hidden (not clickable etc.)
  /// Else it will be visible.
  ///
  /// To better understand the difference to [isTransparent] see the comment
  /// in the [build] method.
  bool isVisible;

  @override
  void initState() {
    isVisible = widget.visible;
    isTransparent = !isVisible;
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    final isFadeIn = !isVisible && widget.visible;
    final isFadeOut = isVisible && !widget.visible;

    if (isFadeIn) {
      /// We set both values directly (opposed to the fade-out above) as
      /// we want the user to be able to use the widget directly, even if it's
      /// still fading in.
      isTransparent = false;
      isVisible = true;
    } else if (isFadeOut) {
      /// We only set [isTransparent] here as the widget should first fade-out
      /// and then change [isVisible] (else it would disapper instantly).
      /// [isVisible] is set `true` later by [AnimatedOpacity.onEnd] in the
      /// build method.
      isTransparent = true;
    } else {
      // visibility wasn't changed so we don't care.
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    /// We can't only use [AnimatedOpacity] as the widget will still be in the
    /// widget tree (which also means clickable etc.) but is transparent to the
    /// user.
    /// We can't only use [Visibility] as this will hide the child directly
    /// without a nice fade-out animation.
    /// So we use both :)
    return AnimatedOpacity(
      opacity: isTransparent ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: widget.curve,

      /// Only make the widget invisible after the fade-out has finished.
      /// For a fade-in we already set [isVisible] in
      /// [_animateVisibilityIfNecessary] directly.
      onEnd: () {
        final isFadeOut = isTransparent && isVisible;
        if (isFadeOut) {
          setState(() {
            isVisible = false;
          });
        }
        if (widget.onEnd != null) {
          widget.onEnd();
        }
      },
      child: Visibility(
        visible: isVisible,
        maintainState: widget.maintainState,
        child: widget.child,
      ),
    );
  }
}
