// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:animator/animator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_navigation_bar.dart';
import 'navigation_experiment/navigation_experiment_option.dart';

part 'tutorial/bnb_tutorial_widget.dart';

const _borderRadiusPanel = BorderRadius.only(
  topRight: Radius.circular(17.5),
  topLeft: Radius.circular(17.5),
);

/// A BottomNavigationBar which can be expaneded by swiping it up.
class ExtendableBottomNavigationBar extends StatefulWidget {
  const ExtendableBottomNavigationBar({
    super.key,
    required this.page,
    required this.currentNavigationItem,
    required this.option,
    this.colorBehindBNB,
  });

  /// The content that is shown behind the [ExtendableBottomNavigationBar].
  /// For example page could be [HomeworkPage], [DashboardPage]
  final Widget page;

  /// Current page, which is selected. [currentNavigationItem] marks the
  /// specific icon with a different color to emphasize that this page is
  /// currently selected.
  final NavigationItem currentNavigationItem;

  /// Through the round corners of the [ExtendableBottomNavigationBar] you can
  /// look behind the [ExtendableBottomNavigationBar]. With [colorBehindBNB] you
  /// set this color.
  ///
  /// Default is [context.scaffoldBackgroundColor]
  final Color? colorBehindBNB;

  final NavigationExperimentOption option;

  @override
  ExtendableBottomNavigationBarState createState() =>
      ExtendableBottomNavigationBarState();
}

@visibleForTesting
class ExtendableBottomNavigationBarState
    extends State<ExtendableBottomNavigationBar> {
  /// [controller] is from "sliding_up_panel" package and is needed to open and
  /// close the [ExtendableBottomNavigationBar].
  final controller = PanelController();

  @override
  Widget build(BuildContext context) {
    if (widget.option == NavigationExperimentOption.drawerAndBnb) {
      return widget.page;
    }
    return Material(
      color: widget.colorBehindBNB ?? context.scaffoldBackgroundColor,
      child: SlidingUpPanel(
        backdropEnabled: true,
        panel: _ExtendableBottomNavigationBarContent(
          controller: controller,
          currentNavigationItem: widget.currentNavigationItem,
          backgroundColor:
              Theme.of(context).isDarkTheme
                  ? ElevationColors.dp8
                  : Colors.grey[100],
        ),
        body: widget.page,
        borderRadius: _borderRadiusPanel,
        minHeight: _ExtendableBottomNavigationBarContent.height(context),
        maxHeight: _ExtendableBottomNavigationBarContent.expendedHeight(
          context,
        ),
        bodyHeight:
            MediaQuery.of(context).size.height -
            _ExtendableBottomNavigationBarContent.height(context),
        controller: controller,
        boxShadow: const [BoxShadow(blurRadius: 0, color: Colors.transparent)],
      ),
    );
  }
}

class _ExtendableBottomNavigationBarContent extends StatefulWidget {
  const _ExtendableBottomNavigationBarContent({
    required this.controller,
    required this.currentNavigationItem,
    this.backgroundColor,
  });

  final PanelController controller;

  /// Current page, which is selected. [currentNavigationItem] marks the
  /// specific icon with a different color to emphasize that this page is
  /// currently selected.
  final NavigationItem currentNavigationItem;

  final Color? backgroundColor;

  @override
  _ExtendableBottomNavigationBarContentState createState() =>
      _ExtendableBottomNavigationBarContentState();

  static double height(BuildContext context) =>
      69.0 + (context.mediaQueryViewPadding.bottom);

  static double expendedHeight(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    final scaledFontSize = MediaQuery.textScalerOf(
      context,
    ).scale(textStyle.fontSize ?? 14);
    return 190.0 +
        (context.mediaQueryViewPadding.bottom / 2) +
        (scaledFontSize * 0.25);
  }
}

class _ExtendableBottomNavigationBarContentState
    extends State<_ExtendableBottomNavigationBarContent> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    // Tutorial Expandable Bottom Navigation Bar
    final bloc = BlocProvider.of<BnbTutorialBloc>(context);
    bloc.shouldShowBnbTutorial().listen((shouldShow) {
      if (shouldShow) {
        openBnbTutorial();
      }
    });
  }

  void openBnbTutorial() {
    final bloc = BlocProvider.of<BnbTutorialBloc>(context);
    bloc.setTutorialAsShown();

    if (!context.isDesktopModus) {
      _overlayEntry = OverlayEntry(
        builder:
            (context) => _BnbTutorial(
              animationController: widget.controller.animationController!,
            ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller.animationController!,
      builder:
          (context, _) => Material(
            color: widget.backgroundColor,
            borderRadius: _borderRadiusPanel,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Theme.of(context).isDarkTheme
                        ? null
                        : Border.all(
                          width:
                              0.8 *
                              (1 -
                                  widget.controller.animationController!.value),
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                borderRadius: _borderRadiusPanel,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SwipeUpLine(controller: widget.controller),
                  FirstNavigationRow(
                    navigationItem: widget.currentNavigationItem,
                    backgroundColor: widget.backgroundColor,
                    controller: widget.controller,
                  ),
                  flexibleSizedBox(),
                  SecondNavigationRow(
                    navigationItem: widget.currentNavigationItem,
                    backgroundColor: widget.backgroundColor,
                    controller: widget.controller,
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      children: [
                        _FeedbackBoxChip(
                          controller: widget.controller,
                          currentNavigationItem: widget.currentNavigationItem,
                        ),
                        const SizedBox(width: 6),
                        _SharezonePlusChip(
                          controller: widget.controller,
                          currentNavigationItem: widget.currentNavigationItem,
                        ),
                        const SizedBox(width: 6),
                        _ProfileChip(
                          controller: widget.controller,
                          currentNavigationItem: widget.currentNavigationItem,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// iPhone 10 & 11 have rounded corners and a little line at the bottom of the
  /// screen. This line makes the second row of [ExtendableBottomNavigationBar]
  /// unreadable. Because of this problem there is a flexible space between
  /// first and second row. If [ExtendableBottomNavigationBar] is closed,
  /// SizedBox.height will be so high, that the second row doesn't appear on the
  /// screen anymore (like a SafeArea). If [ExtendableBottomNavigationBar] is
  /// open, SizedBox.height will be reduced, so that first and second row are
  /// directly below each other. Picture of the problems and the current
  /// Solution: https://bit.ly/3fW9ecw
  Widget flexibleSizedBox() => AnimatedBuilder(
    animation: widget.controller.animationController!,
    builder: (context, child) {
      return SizedBox(
        height:
            8 +
            (context.mediaQueryViewPadding.bottom *
                (1 - widget.controller.animationController!.value)),
      );
    },
  );
}

/// A little line, which indicates that the user can swipe up
/// the [ExtendableBottomNavigationBar]. Will also open the
/// [ExtendableBottomNavigationBar] if tapped on.
class _SwipeUpLine extends StatelessWidget {
  const _SwipeUpLine({this.controller});

  /// [controller] is needed to open the [ExtendableBottomNavigationBar], if the
  /// user taps on this widget.
  ///
  /// If [controller] is null, this function will be disabled.
  final PanelController? controller;

  @override
  Widget build(BuildContext context) {
    final isBnbExpanded = controller?.isPanelOpen ?? false;
    return Semantics(
      label:
          '${isBnbExpanded ? 'Schließt' : 'Öffnet'} die erweiterte Navigationsleiste',
      child: GestureDetector(
        onTap: () => onTap(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
          child: Center(
            child: Container(
              height: 4.5,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.grey[400]!.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTap(BuildContext context) async {
    if (controller == null) return;

    controller!.isPanelOpen ? controller!.close() : controller!.open();
    _logAnalytics(context);
  }

  void _logAnalytics(BuildContext context) {
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    analytics.logUsedSwipeUpLine();
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.controller,
    required this.currentNavigationItem,
  });

  final PanelController controller;
  final NavigationItem currentNavigationItem;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: NavigationItem.accountPage.getName(),
      child: _Chip(
        controller: controller,
        navigationItem: NavigationItem.accountPage,
        currentNavigationItem: currentNavigationItem,
        showName: false,
      ),
    );
  }
}

class _FeedbackBoxChip extends StatelessWidget {
  const _FeedbackBoxChip({
    required this.controller,
    required this.currentNavigationItem,
  });

  final PanelController controller;
  final NavigationItem currentNavigationItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _Chip(
        controller: controller,
        navigationItem: NavigationItem.feedbackBox,
        currentNavigationItem: currentNavigationItem,
        showName: true,
      ),
    );
  }
}

class _SharezonePlusChip extends StatelessWidget {
  const _SharezonePlusChip({
    required this.controller,
    required this.currentNavigationItem,
  });

  final PanelController controller;
  final NavigationItem currentNavigationItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _Chip(
        controller: controller,
        navigationItem: NavigationItem.sharezonePlus,
        currentNavigationItem: currentNavigationItem,
        showName: true,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.controller,
    required this.navigationItem,
    required this.currentNavigationItem,
    required this.showName,
  });

  /// [PanelController] is from the "sliding_up_panel" and is needed to close
  /// the [ExtendableBottomNavigationBar], when the chip is tapped.
  final PanelController controller;

  final NavigationItem navigationItem;
  final NavigationItem currentNavigationItem;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(50));
    final color =
        Theme.of(context).isDarkTheme
            ? Theme.of(context).primaryColor
            : darkBlueColor;
    return InkWell(
      borderRadius: borderRadius,
      onTap: () async {
        controller.close();
        if (currentNavigationItem != navigationItem) {
          await waitForClosingPanel();
          if (!context.mounted) return;
          final bloc = BlocProvider.of<NavigationBloc>(context);
          bloc.navigateTo(navigationItem);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(
            alpha: Theme.of(context).isDarkTheme ? 0.15 : 0.2,
          ),
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              IconTheme(
                data: context.theme.iconTheme.copyWith(color: color, size: 20),
                child: navigationItem.getIcon(),
              ),
              if (showName) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: AutoSizeText(
                        navigationItem.getName(),
                        style: TextStyle(color: color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> waitForClosingPanel() async =>
    Future.delayed(const Duration(milliseconds: 50));
