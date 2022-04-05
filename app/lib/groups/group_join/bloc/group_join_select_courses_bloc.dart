// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_bloc.dart';
import 'package:sharezone/groups/group_join/models/group_info_with_selection_state.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';

/// In diesem Bloc wird die Auswahl von Kursen einer Schulklasse ermöglicht. Dazu muss
/// ein [RequireCourseSelectionsJoinResult] übergeben werden. Nach Auswahl und Bestätigung
/// gibt der Bloc die ausgewählten Kurse als Liste zurück und beginnt einen neuen JoinVersuch.
/// Dazu ruft der Bloc die Methode enterValueWithCourseList im [GroupJoinBloc] auf.
class GroupJoinSelectCoursesBloc extends BlocBase {
  final GroupJoinBloc groupJoinBloc;
  final RequireCourseSelectionsJoinResult joinResult;

  final _coursesListSubject =
      BehaviorSubject<List<GroupInfoWithSelectionState>>();

  GroupJoinSelectCoursesBloc({
    @required this.joinResult,
    @required this.groupJoinBloc,
  }) {
    _initializeCoursesSelectionMap();
  }

  void _initializeCoursesSelectionMap() {
    final list = joinResult.courses;
    list.sortAlphabetically();
    _coursesListSubject.add(list);
  }

  String get groupName => joinResult.groupInfo.name;

  Stream<List<GroupInfoWithSelectionState>> get coursesList =>
      _coursesListSubject;

  void setSelectionState(GroupKey groupKey, bool isSelected) {
    final list = _coursesListSubject.valueOrNull.toList();
    list.updateSelectionStateOf(groupKey, isSelected);
    _coursesListSubject.add(list);
  }

  /// Der Nutzer hebt die aktuelle Auswahl beim Überspringen auf und tritt der
  /// Schulklasse sofort mit der Vorauswahl der Klasse bei.
  Future<void> skip() async {
    // Die Liste wird wieder neu initialisiert, um die selbe Auswahl wie bei
    // beim Start zu erhalten.
    _initializeCoursesSelectionMap();
    await submit();
  }

  Future<void> submit() async {
    final coursesList = _coursesListSubject.valueOrNull
        .where((groupInfo) => groupInfo.isSelected)
        .map((groupInfo) => groupInfo.groupKey)
        .toList();
    await groupJoinBloc.enterValueWithCourseList(coursesList);
  }

  @override
  void dispose() {
    _coursesListSubject.close();
  }
}

extension on List<GroupInfoWithSelectionState> {
  void sortAlphabetically() {
    sort((g1, g2) => g1.name.compareTo(g2.name));
  }

  int indexOfGroupInfoWithId(String id) =>
      indexWhere((object) => object.id == id);

  List<GroupInfoWithSelectionState> updateSelectionStateOf(
      GroupKey groupKey, bool newSelectionState) {
    final indexOfItem = indexOfGroupInfoWithId(groupKey.id);
    final item = this[indexOfItem];
    replaceRange(indexOfItem, indexOfItem + 1,
        [item.copyWithSelectionState(newSelectionState)]);
    return this;
  }
}
