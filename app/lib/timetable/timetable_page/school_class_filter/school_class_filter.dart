// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'school_class_filter_view.dart';

/// [SchoolClassFilterBottomBar] ermöglicht dem Nutzer mit mehr als einer Schulklasse
/// den Stundenplan (mit Terminen) nur für eine spezifische Schulklasse
/// anzuzeigen. Somit werden alle anderen Termine/Schulstunden anderer
/// Schulklassen oder Kurse ohne verknüpfte Schulklasse ausgeblendet. Dieses
/// Feature ist vor allem für Eltern sehr hilfreich, um den Stundenplan nur für
/// ein bestimmtes Kind anzuzeigen.
class SchoolClassFilterBottomBar extends StatefulWidget {
  const SchoolClassFilterBottomBar({Key? key, this.backgroundColor})
      : super(key: key);

  final Color? backgroundColor;

  @override
  _SchoolClassFilterBottomBarState createState() =>
      _SchoolClassFilterBottomBarState();
}

class _SchoolClassFilterBottomBarState
    extends State<SchoolClassFilterBottomBar> {
  /// Die Tap-Position wird für das Popup-Menü bei Geräten mit einem großen
  /// Screen benötigt.
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableBloc>(context);
    return StreamBuilder<SchoolClassFilterView>(
      stream: bloc.schoolClassFilterView,
      initialData: bloc.schoolClassFilterView.valueOrNull,
      builder: (context, snapshot) {
        final view = snapshot.data;

        // Die Auswahl der Schulklasse soll nur angezeigt werden, wenn der
        // Nutzer in mehr als einer Schulklasse ist. Ansonsten bringt diese
        // Funktion keinen Mehrwert und ist somit unnötig, wenn es angezeigt
        // wird.
        if (view == null || !view.hasMoreThanOneSchoolClass) return Text("");

        return Material(
          key: const ValueKey('school-class-filter-widget-test'),
          elevation: 0,
          color: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                InkWell(
                  onTapDown: _storeTapPosition,
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => _openAndHandleSelectionMenu(context, bloc, view),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GroupIcon(),
                        const SizedBox(width: 12),
                        _Text(view: view),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _openAndHandleSelectionMenu(BuildContext context,
      TimetableBloc bloc, SchoolClassFilterView view) async {
    final selectedOption = await _openSelectionMenu(view);
    if (selectedOption == null) {
      return;
    }

    if (_shouldOpenSharezonePlusPage(context, selectedOption)) {
      _openSharezonePlusPage(context);
    } else {
      bloc.changeSchoolClassFilter(selectedOption);
    }
  }

  bool _shouldOpenSharezonePlusPage(
      BuildContext context, SchoolClassFilter selectedOption) {
    final isPlusEnabled = context.read<SubscriptionEnabledFlag>().isEnabled;
    final hasPlus = context.read<SubscriptionService>().isSubscriptionActive();
    return selectedOption.isPlusRequiredFilter && !hasPlus && isPlusEnabled;
  }

  Future<void> _openSharezonePlusPage(BuildContext context) async {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);
    navigationBloc.navigateTo(NavigationItem.sharezonePlus);
  }

  /// Bei Geräten mit einem großen Screen wird kein BottomModelSheet verwendet,
  /// da dies für große Geräte unpraktisch ist. Stattdessen wird ein Popup-Menü
  /// verwendet.
  Future<SchoolClassFilter?> _openSelectionMenu(
      SchoolClassFilterView view) async {
    if (context.isDesktopModus) {
      return _openDesktopMenu(view);
    }
    return _openMobileMenu(view);
  }

  Future<SchoolClassFilter?> _openMobileMenu(SchoolClassFilterView view) async {
    return showModalBottomSheet<SchoolClassFilter>(
      context: context,
      builder: (context) => _SelectionSheet(view: view),
    );
  }

  PopupMenuItem<SchoolClassFilter> schoolClassToItem(
      SchoolClassView schoolClass) {
    final value = SchoolClassFilter.showSchoolClass(schoolClass.id);
    return PopupMenuItem(
      child: _DesktopMenuTile(
        isSelected: schoolClass.isSelected,
        title: schoolClass.name,
        filter: value,
      ),
      value: value,
    );
  }

  Future<SchoolClassFilter?> _openDesktopMenu(
      SchoolClassFilterView view) async {
    final showAllGroups = SchoolClassFilter.showAllGroups();
    return showMenu<SchoolClassFilter>(
      context: context,
      position: _getMousePosition(context),
      constraints: BoxConstraints(
        minWidth: 200,
        maxWidth: 360,
      ),
      items: [
        PopupMenuItem(
          child: _DesktopMenuTile(
            isSelected: !view.hasSchoolClassSelected,
            title: "Alle Schulklassen",
            filter: showAllGroups,
          ),
          value: showAllGroups,
        ),
        const PopupMenuDivider(),
        for (final schoolClass in view.schoolClassList)
          schoolClassToItem(schoolClass)
      ],
    );
  }

  RelativeRect _getMousePosition(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      _tapPosition! & const Size(40, 40),
      Offset.zero & overlay.size,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.view,
  }) : super(key: key);

  final SchoolClassFilterView view;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        "Schulklasse: ${view.hasSchoolClassSelected ? view.currentSchoolClassName : 'Alle'}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _DesktopMenuTile extends StatelessWidget {
  const _DesktopMenuTile({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.filter,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final SchoolClassFilter filter;

  @override
  Widget build(BuildContext context) {
    const icon = Padding(
      padding: EdgeInsets.only(right: 8),
      child: Icon(Icons.check, color: Colors.green),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          isSelected ? icon : const SizedBox(width: 32),
          SizedBox(
            child: Text(title),
            width: 200,
          ),
          _SelectionSheetTileTrailing(
            isSelected: isSelected,
            activeIcon: Container(),
            filter: filter,
          )
        ],
      ),
    );
  }
}

class _SelectionSheet extends StatelessWidget {
  const _SelectionSheet({Key? key, required this.view}) : super(key: key);

  final SchoolClassFilterView view;

  @override
  Widget build(BuildContext context) {
    final isASchoolClassSelected = view.selectedSchoolClass != null;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            _SelectionSheetTile(
              title: "Alle Schulklassen",
              isSelected: !isASchoolClassSelected,
              filter: SchoolClassFilter.showAllGroups(),
            ),
            const Divider(),
            ...[
              for (final schoolClass in view.schoolClassList)
                _SelectionSheetTile(
                  title: schoolClass.name,
                  isSelected: schoolClass.isSelected,
                  filter: SchoolClassFilter.showSchoolClass(schoolClass.id),
                ),
            ]
          ],
        ),
      ),
    );
  }
}

class _SelectionSheetTile extends StatelessWidget {
  const _SelectionSheetTile({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.filter,
  }) : super(key: key);

  final bool isSelected;
  final String title;
  final SchoolClassFilter filter;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      child: ListTile(
        title: Text(title),
        onTap: () => Navigator.pop(context, filter),
        trailing: _SelectionSheetTileTrailing(
          isSelected: isSelected,
          filter: filter,
          activeIcon: Icon(Icons.check, color: Colors.green),
        ),
      ),
    );
  }
}

class _SelectionSheetTileTrailing extends StatelessWidget {
  const _SelectionSheetTileTrailing({
    required this.isSelected,
    required this.filter,
    required this.activeIcon,
  });

  final bool isSelected;
  final SchoolClassFilter filter;

  /// The icon that is displayed when the tile is selected.
  final Widget activeIcon;

  @override
  Widget build(BuildContext context) {
    final isPlusEnabled = context.read<SubscriptionEnabledFlag>().isEnabled;
    final hasPlus = context.read<SubscriptionService>().isSubscriptionActive();

    if (filter.isPlusRequiredFilter && !hasPlus && isPlusEnabled)
      return SharezonePlusCard();
    return isSelected ? activeIcon : Container();
  }
}

class _GroupIcon extends StatelessWidget {
  const _GroupIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      themeIconData(Icons.group, cupertinoIcon: SFSymbols.person_2_fill),
      color: context.isDarkThemeEnabled ? Colors.white : Colors.grey[600],
    );
  }
}
