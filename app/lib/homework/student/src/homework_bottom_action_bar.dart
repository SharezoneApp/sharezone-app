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
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class HomeworkBottomActionBar extends StatelessWidget {
  const HomeworkBottomActionBar({
    Key key,
    @required this.backgroundColor,
  }) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _SortButton(),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              var action =
                  await showRoundedModalBottomSheet<_BottomSheetAction>(
                      context: context,
                      builder: (context) => _MoreActionsBottomSheet(),
                      defaultValue: _BottomSheetAction.abort,
                      isScrollControlled: true);
              // ignore:close_sinks
              final bloc = BlocProvider.of<HomeworkPageBloc>(context);
              switch (action) {
                case _BottomSheetAction.completeOverdue:
                  bloc.add(CompletedAllOverdue());
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

Future<T> showRoundedModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color backgroundColor,
  double elevation,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  T defaultValue,
}) async {
  assert(context != null);
  assert(builder != null);
  assert(isScrollControlled != null);
  assert(useRootNavigator != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  T res = await showModalBottomSheet<T>(
    context: context,
    builder: builder,
    backgroundColor: backgroundColor,
    elevation: elevation,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  return res ??= defaultValue;
}

enum _BottomSheetAction { completeOverdue, abort }

class _MoreActionsBottomSheet extends StatelessWidget {
  const _MoreActionsBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .2,
      minChildSize: .2,
      maxChildSize: 1,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            _CompleteOverdue(),
            _MoreIdeas(opacity: .65),
          ],
        ),
      ),
    );
  }
}

class _CompleteOverdue extends StatelessWidget {
  const _CompleteOverdue({
    Key key,
  }) : super(key: key);

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
  const _MoreIdeas({
    Key key,
    this.opacity = 1,
  }) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.feedback,
        color: Theme.of(context).iconTheme.color.withOpacity(opacity),
      ),
      title: Text(
        "Noch Ideen?",
        style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyText2
                .color
                .withOpacity(opacity)),
      ),
      onTap: () {
        Navigator.pop(context);
        final bloc = BlocProvider.of<NavigationBloc>(context);
        bloc.navigateTo(NavigationItem.feedbackBox);
      },
    );
  }
}

class _SortButton extends StatelessWidget {
  String _sortString(HomeworkSort sort) {
    if (sort == null) return '';
    switch (sort) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return 'Sortiere nach Datum';
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return 'Sortiere nach Fach';
    }
    throw UnimplementedError('HomeworkSort $sort not implemented');
  }

  HomeworkSort _getNextSort(HomeworkSort current) {
    switch (current) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return HomeworkSort.subjectSmallestDateAndTitleSort;
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return HomeworkSort.smallestDateSubjectAndTitle;
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<HomeworkPageBloc>(context);

    return StreamBuilder<Success>(
      stream: bloc.whereType<Success>(),
      builder: (context, snapshot) {
        final currentSort = snapshot?.data?.open?.sorting;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            key: Key("change_homework_sorting"),
            onTap: () =>
                bloc.add(OpenHwSortingChanged(_getNextSort(currentSort))),
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
