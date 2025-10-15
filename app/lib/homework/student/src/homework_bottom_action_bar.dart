// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
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
                final action =
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
class SortButton extends StatelessWidget {
  @visibleForTesting
  static const sortByDateSortButtonUiString = "Sortiere nach Datum";
  @visibleForTesting
  static const sortBySubjectSortButtonUiString = "Sortiere nach Fach";

  const SortButton({
    super.key,
    required this.onSortingChanged,
    required this.currentHomeworkSortStream,
  });

  final void Function(HomeworkSort newSort) onSortingChanged;
  final Stream<HomeworkSort> currentHomeworkSortStream;

  String _sortString(HomeworkSort sort) {
    switch (sort) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return sortByDateSortButtonUiString;
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return sortBySubjectSortButtonUiString;
    }
  }

  HomeworkSort _getNextSort(HomeworkSort current) {
    switch (current) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return HomeworkSort.subjectSmallestDateAndTitleSort;
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return HomeworkSort.smallestDateSubjectAndTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeworkSort>(
      stream: currentHomeworkSortStream,
      builder: (context, snapshot) {
        final currentSort =
            snapshot.data ?? HomeworkSort.smallestDateSubjectAndTitle;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            key: const Key("change_homework_sorting"),
            onTap: () => onSortingChanged(_getNextSort(currentSort)),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.sort),
                ),
                Text(
                  _sortString(currentSort),
                  key: ValueKey<String>(_sortString(currentSort)),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
