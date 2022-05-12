// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/extendable_bottom_navigation_bar.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void _logNavBottomBarEvent(NavigationItem item, NavigationAnalytics analytics) {
  analytics.logBottomNavigationBarEvent(item);
}

/// This is the Bnb for [NavigationExperimentOption.drawerAndBnB].
class BnbAndDrawerBottomNavigationBar extends StatelessWidget {
  const BnbAndDrawerBottomNavigationBar({Key key, this.navigationItem})
      : super(key: key);

  final NavigationItem navigationItem;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NavigationBloc>(context);
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 0, color: Colors.grey[400]),
        _BottomNavBarWithNonSelectionAllowed(
          safeArea: true,
          currentItem: navigationItem,
          items: const [
            NavigationItem.overview,
            NavigationItem.group,
            NavigationItem.homework,
            NavigationItem.timetable,
            NavigationItem.blackboard,
          ],
          onNavigationItemSelected: (item) async {
            bloc.navigateTo(item);
            _logNavBottomBarEvent(item, analytics);
          },
        ),
      ],
    );
  }
}

/// First row of [ExtendableBottomNavigationBar]. This row is always visibile.
class FirstNavigationRow extends StatelessWidget {
  const FirstNavigationRow({
    Key key,
    this.navigationItem,
    this.backgroundColor,
    this.controller,
  }) : super(key: key);

  final NavigationItem navigationItem;
  final Color backgroundColor;

  /// [controller] is from "sliding_up_panel" package and is needed to open and
  /// close the [ExtendableBottomNavigationBar].
  final PanelController controller;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NavigationBloc>(context);
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      initialData: navigationCache.currentNavigation.valueOrNull,
      stream: navigationCache.currentNavigation,
      builder: (context, snapshot) {
        final option =
            snapshot.data ?? NavigationExperimentOption.extendableBnb;
        return _BottomNavBarWithNonSelectionAllowed(
          currentItem: navigationItem,
          backgroundColor: backgroundColor,
          onMoreButtonTapped: () =>
              controller.isPanelOpen ? controller.close() : controller.open(),
          items: option == NavigationExperimentOption.extendableBnb
              ? getExtendableBnbItems()
              : getExtendableWithMoreButtonBnbItems(),
          onNavigationItemSelected: (item) async {
            if (controller.isPanelOpen) {
              controller.close();
              await waitForClosingPanel();
            }
            bloc.navigateTo(item);
            _logNavBottomBarEvent(item, analytics);
          },
        );
      },
    );
  }

  List<NavigationItem> getExtendableBnbItems() {
    return const [
      NavigationItem.overview,
      NavigationItem.filesharing,
      NavigationItem.homework,
      NavigationItem.timetable,
      NavigationItem.blackboard,
    ];
  }

  List<NavigationItem> getExtendableWithMoreButtonBnbItems() {
    return const [
      NavigationItem.overview,
      NavigationItem.blackboard,
      NavigationItem.homework,
      NavigationItem.timetable,
      NavigationItem.more,
    ];
  }
}

/// Second row of [ExtendableBottomNavigationBar]. This row is only visible, if
/// the user expands the navigation bar.
class SecondNavigationRow extends StatelessWidget {
  const SecondNavigationRow({
    Key key,
    @required this.navigationItem,
    @required this.controller,
    this.backgroundColor,
  }) : super(key: key);

  final NavigationItem navigationItem;
  final Color backgroundColor;

  /// [controller] is from "sliding_up_panel" package and is needed to open and
  /// close the [ExtendableBottomNavigationBar].
  final PanelController controller;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NavigationBloc>(context);
    final analytics = BlocProvider.of<NavigationAnalytics>(context);
    final navigationCache = BlocProvider.of<NavigationExperimentCache>(context);
    return StreamBuilder<NavigationExperimentOption>(
      initialData: navigationCache.currentNavigation.valueOrNull,
      stream: navigationCache.currentNavigation,
      builder: (context, snapshot) {
        final option =
            snapshot.data ?? NavigationExperimentOption.extendableBnb;
        return _BottomNavBarWithNonSelectionAllowed(
          currentItem: navigationItem,
          backgroundColor: backgroundColor,
          onMoreButtonTapped: () =>
              controller.isPanelOpen ? controller.close() : controller.open(),
          items: option == NavigationExperimentOption.extendableBnb
              ? getExtendableBnbItems()
              : getExtendableWithMoreButtonBnbItems(),
          onNavigationItemSelected: (item) async {
            controller.close();
            await waitForClosingPanel();
            bloc.navigateTo(item);
            _logNavBottomBarEvent(item, analytics);
          },
        );
      },
    );
  }

  List<NavigationItem> getExtendableBnbItems() {
    return [
      NavigationItem.group,
      NavigationItem.events,
      NavigationItem.settings,
    ];
  }

  List<NavigationItem> getExtendableWithMoreButtonBnbItems() {
    return [
      NavigationItem.group,
      NavigationItem.filesharing,
      NavigationItem.events,
      NavigationItem.settings,
    ];
  }
}

/// A BottomNavigationBar that contrary to Flutter's [BottomNavigationBar]
/// allows for no item to be selected. This is the case when e.g. the profile
/// page is opened which is not located in the BNB in Sharezone.
///
/// When no item is selected the [_BottomNavBarWithNonSelectionAllowed] still
/// shows all items but none of them are highlighted/active.
///
/// Flutter's [BottomNavigationBar] doesn't allow a non selected state. If this
/// happens, a error will occure.
class _BottomNavBarWithNonSelectionAllowed extends StatelessWidget {
  const _BottomNavBarWithNonSelectionAllowed({
    Key key,
    @required this.items,
    @required this.currentItem,
    @required this.onNavigationItemSelected,
    this.backgroundColor,
    this.onMoreButtonTapped,
    this.safeArea = false,
  }) : super(key: key);

  final List<NavigationItem> items;
  final NavigationItem currentItem;
  final Color backgroundColor;

  final ValueChanged<NavigationItem> onNavigationItemSelected;
  final VoidCallback onMoreButtonTapped;

  /// [safeArea] is needed fo the [BnbAndDrawerBottomNavigationBar].
  ///
  /// Default is false.
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: SafeArea(
        bottom: safeArea,
        top: safeArea,
        left: safeArea,
        right: safeArea,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 4),
            for (final item in items)
              _BottomNavItem(
                item: item,
                isSelected: item == currentItem,
                onMoreButtonTapped: onMoreButtonTapped,
                onNavigationItemSelected: onNavigationItemSelected,
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    Key key,
    @required this.item,
    @required this.onMoreButtonTapped,
    @required this.isSelected,
    @required this.onNavigationItemSelected,
  }) : super(key: key);

  final NavigationItem item;
  final bool isSelected;

  final ValueChanged<NavigationItem> onNavigationItemSelected;
  final VoidCallback onMoreButtonTapped;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkResponse(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
          child: IconTheme(
            data: IconThemeData(color: _getColor(context), size: 28),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 9.5,
                color: _getColor(context),
                fontFamily: rubik,
              ),
              textAlign: TextAlign.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  item.getIcon(),
                  const SizedBox(height: 1.5),
                  AutoSizeText(
                    item.getName(),
                    maxLines: 1,
                    minFontSize: 5,
                    maxFontSize: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: isSelected
            ? null
            : () {
                if (item == NavigationItem.more) {
                  onMoreButtonTapped();
                } else {
                  onNavigationItemSelected(item);
                }
              },
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (isDarkThemeEnabled(context)) {
      return isSelected ? Colors.white : Colors.grey[500];
    }
    return isSelected ? context.primaryColor : Colors.grey[500];
  }
}
