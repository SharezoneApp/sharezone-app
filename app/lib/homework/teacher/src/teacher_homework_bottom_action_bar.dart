// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:rxdart/rxdart.dart';

class TeacherHomeworkBottomActionBar extends StatelessWidget {
  const TeacherHomeworkBottomActionBar({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: backgroundColor,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TeacherSortButton(),
        ],
      ),
    );
  }
}

class TeacherSortButton extends StatelessWidget {
  @visibleForTesting
  static const sortByDateSortButtonUiString = "Sortiere nach Datum";
  @visibleForTesting
  static const sortBySubjectSortButtonUiString = "Sortiere nach Fach";

  const TeacherSortButton({super.key});

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
    // ignore: close_sinks
    final bloc = BlocProvider.of<TeacherHomeworkPageBloc>(context);

    return StreamBuilder<Success>(
      stream: bloc.stream.whereType<Success>(),
      builder: (context, snapshot) {
        final currentSort = snapshot.data?.open.sorting ??
            HomeworkSort.subjectSmallestDateAndTitleSort;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            key: const Key("change_homework_sorting"),
            onTap: () =>
                bloc.add(OpenHwSortingChanged(_getNextSort(currentSort))),
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
