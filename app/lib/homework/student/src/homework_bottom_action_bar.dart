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
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class HomeworkBottomActionBar extends StatelessWidget {
  const HomeworkBottomActionBar({
    super.key,
    required this.backgroundColor,
    required this.onSortingChanged,
    required this.onCompletedAllOverdue,
    required this.showOverflowMenu,
    required this.currentHomeworkSortStream,
  });

  final Color? backgroundColor;
  final Stream<HomeworkSort> currentHomeworkSortStream;
  final void Function(HomeworkSort newSort) onSortingChanged;
  final VoidCallback onCompletedAllOverdue;
  final bool showOverflowMenu;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SortButton(
            onSortingChanged: onSortingChanged,
            currentHomeworkSortStream: currentHomeworkSortStream,
          ),
          if (showOverflowMenu)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () async {
                var action =
                    await showRoundedModalBottomSheet<_BottomSheetAction>(
                      context: context,
                      builder: (context) => const _MoreActionsBottomSheet(),
                      defaultValue: _BottomSheetAction.abort,
                      isScrollControlled: true,
                    );
                if (!context.mounted) return;

                switch (action) {
                  case _BottomSheetAction.completeOverdue:
                    onCompletedAllOverdue();
                    break;
                  case _BottomSheetAction.abort:
                  default:
                }
              },
            ),
        ],
      ),
    );
  }
}

enum _BottomSheetAction { completeOverdue, abort }

class _MoreActionsBottomSheet extends StatelessWidget {
  const _MoreActionsBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .2,
      minChildSize: .2,
      maxChildSize: 1,
      builder:
          (context, controller) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_CompleteOverdue(), _MoreIdeas(opacity: .65)],
            ),
          ),
    );
  }
}

class _CompleteOverdue extends StatelessWidget {
  const _CompleteOverdue();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.hourglass_full),
      title: const Text("Überfällige Hausaufgaben abhaken"),
      onTap: () => Navigator.pop(context, _BottomSheetAction.completeOverdue),
    );
  }
}

class _MoreIdeas extends StatelessWidget {
  const _MoreIdeas({this.opacity = 1});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.feedback,
        color: Theme.of(context).iconTheme.color!.withValues(alpha: opacity),
      ),
      title: Text(
        "Noch Ideen?",
        style: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodyMedium!.color!.withValues(alpha: opacity),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        final bloc = BlocProvider.of<NavigationBloc>(context);
        bloc.navigateTo(NavigationItem.feedbackBox);
      },
    );
  }
}

@visibleForTesting
class SortButton extends StatefulWidget {
  @visibleForTesting
  static const sortByDateSortButtonUiString = "Sortiere nach Datum";
  @visibleForTesting
  static const sortBySubjectSortButtonUiString = "Sortiere nach Fach";
  @visibleForTesting
  static const sortByWeekdaySortButtonUiString = "Sortiere nach Wochentag";

  const SortButton({
    super.key,
    required this.onSortingChanged,
    required this.currentHomeworkSortStream,
  });

  final void Function(HomeworkSort newSort) onSortingChanged;
  final Stream<HomeworkSort> currentHomeworkSortStream;

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  Offset? _tapPosition;

  String _sortString(HomeworkSort sort) {
    switch (sort) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return SortButton.sortByDateSortButtonUiString;
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return SortButton.sortBySubjectSortButtonUiString;
      case HomeworkSort.weekdayDateSubjectAndTitle:
        return SortButton.sortByWeekdaySortButtonUiString;
    }
  }

  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _openAndHandleSelection(
    BuildContext context,
    HomeworkSort currentSort,
  ) async {
    final selectedSort = await _openSelectionMenu(context, currentSort);
    if (!mounted) return;
    if (selectedSort == null || selectedSort == currentSort) {
      return;
    }
    widget.onSortingChanged(selectedSort);
  }

  Future<HomeworkSort?> _openSelectionMenu(
    BuildContext context,
    HomeworkSort currentSort,
  ) {
    if (context.isDesktopModus) {
      return _openDesktopMenu(context, currentSort);
    }
    return _openMobileMenu(context, currentSort);
  }

  Future<HomeworkSort?> _openMobileMenu(
    BuildContext context,
    HomeworkSort currentSort,
  ) {
    return showModalBottomSheet<HomeworkSort>(
      context: context,
      builder:
          (context) => _SortSelectionSheet(
            currentSort: currentSort,
            sortStringBuilder: _sortString,
          ),
    );
  }

  Future<HomeworkSort?> _openDesktopMenu(
    BuildContext context,
    HomeworkSort currentSort,
  ) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final tapPosition = _tapPosition ?? overlay.size.center(Offset.zero);
    return showMenu<HomeworkSort>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 360),
      items: [
        for (final sort in HomeworkSort.values)
          PopupMenuItem<HomeworkSort>(
            value: sort,
            child: _SortDesktopMenuTile(
              title: _sortString(sort),
              isSelected: sort == currentSort,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeworkSort>(
      stream: widget.currentHomeworkSortStream,
      builder: (context, snapshot) {
        final currentSort =
            snapshot.data ?? HomeworkSort.smallestDateSubjectAndTitle;
        final sortText = _sortString(currentSort);
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            key: const Key("change_homework_sorting"),
            onTapDown: _storeTapPosition,
            onTap: () => _openAndHandleSelection(context, currentSort),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.sort),
                ),
                Text(sortText, key: ValueKey<String>(sortText)),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SortSelectionSheet extends StatelessWidget {
  const _SortSelectionSheet({
    required this.currentSort,
    required this.sortStringBuilder,
  });

  final HomeworkSort currentSort;
  final String Function(HomeworkSort sort) sortStringBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final sort in HomeworkSort.values)
            _SortSelectionTile(
              sort: sort,
              isSelected: sort == currentSort,
              title: sortStringBuilder(sort),
            ),
        ],
      ),
    );
  }
}

class _SortSelectionTile extends StatelessWidget {
  const _SortSelectionTile({
    required this.sort,
    required this.isSelected,
    required this.title,
  });

  final HomeworkSort sort;
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      child: ListTile(
        title: Text(title),
        trailing:
            isSelected ? const Icon(Icons.check, color: Colors.green) : null,
        onTap: () => Navigator.pop(context, sort),
      ),
    );
  }
}

class _SortDesktopMenuTile extends StatelessWidget {
  const _SortDesktopMenuTile({required this.title, required this.isSelected});

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const selectedIcon = Padding(
      padding: EdgeInsets.only(right: 8),
      child: Icon(Icons.check, color: Colors.green),
    );
    return Row(
      children: [
        isSelected ? selectedIcon : const SizedBox(width: 32),
        Expanded(child: Text(title)),
      ],
    );
  }
}
