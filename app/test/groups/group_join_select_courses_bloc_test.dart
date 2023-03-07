// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_bloc.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_select_courses_bloc.dart';
import 'package:sharezone/groups/group_join/models/group_info_with_selection_state.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGroupJoinBloc extends GroupJoinBloc {
  // Resent, da der JoinVersuch hier ja ein zweites Mal erfolgt, aber diesmal mit einer
  // zusätzlichen Kursliste.
  bool hasResentJoinRequest = false;
  List<String> sentCourseIds;

  MockGroupJoinBloc() : super(null, null);

  @override
  Future<void> enterValueWithCourseList(List<GroupKey> courseList) {
    hasResentJoinRequest = true;
    sentCourseIds = courseList.map((groupKey) => groupKey.id).toList();
    return Future.value();
  }
}

GroupInfo _mockSchoolClass() {
  return GroupInfo(
    id: 'klassenid',
    groupType: GroupType.schoolclass,
    name: 'Klasse 8b',
    abbreviation: "Gr",
    design: Design.standard(),
    meetingID: null,
    joinLink: null,
    sharecode: null,
  );
}

GroupInfoWithSelectionState _courseWith({
  String id,
  String name,
  bool isSelected = true,
}) {
  return GroupInfoWithSelectionState(
    id: id ?? randomAlpha(5),
    groupType: GroupType.course,
    name: name ?? randomAlpha(5),
    abbreviation: "Gr",
    design: Design.standard(),
    isSelected: isSelected,
  );
}

GroupKey _groupKeyOfCourse(String groupId) {
  return GroupKey(id: groupId, groupType: GroupType.course);
}

void main() {
  group('GroupJoinSelectCoursesBlocTest', () {
    MockGroupJoinBloc mockGroupJoinBloc;
    setUp(() {
      mockGroupJoinBloc = MockGroupJoinBloc();
    });

    GroupJoinSelectCoursesBloc _blocWith({
      @required List<GroupInfoWithSelectionState> courses,
    }) {
      return GroupJoinSelectCoursesBloc(
        joinResult: RequireCourseSelectionsJoinResult(
            groupInfo: _mockSchoolClass(),
            courses: courses,
            enteredValue: 'ABCDEF'),
        groupJoinBloc: mockGroupJoinBloc,
      );
    }

    test('sorts courselist alphabetically', () async {
      // Arrange
      final bloc = _blocWith(courses: [
        _courseWith(name: 'Englisch'),
        _courseWith(name: 'Deutsch'),
        _courseWith(name: 'Spanisch'),
        _courseWith(name: 'Französisch'),
      ]);
      // Act
      final coursesList = await bloc.coursesList.first;
      // Assert
      expect(coursesList.map((course) => course.name), [
        'Deutsch',
        'Englisch',
        'Französisch',
        'Spanisch',
      ]);
    });

// Hierbei wird überprüft, dass beim submit dies auch an den GroupJoinBloc übergeben wird.
    test('sends new Join Request to GroupJoinBloc', () async {
      // Arrange
      final bloc = _blocWith(courses: [
        _courseWith(name: 'Englisch'),
        _courseWith(name: 'Deutsch'),
        _courseWith(name: 'Spanisch'),
        _courseWith(name: 'Französisch'),
      ]);
      // Act
      await bloc.submit();
      // Assert
      expect(mockGroupJoinBloc.hasResentJoinRequest, true);
    });

    test('updates isSelected, when the selectionState was updated', () async {
      // Arrange
      final bloc = _blocWith(courses: [
        _courseWith(id: 'deutsch', isSelected: false),
      ]);
      // Act
      final courseBefore = await bloc.coursesList.withCourse(id: 'deutsch');
      bloc.setSelectionState(_groupKeyOfCourse('deutsch'), true);
      final courseAfter = await bloc.coursesList.withCourse(id: 'deutsch');

      // Assert
      expect(courseBefore.isSelected, false);
      expect(courseAfter.isSelected, true);
    });

    test('only sends new request with selected courses', () async {
      // Arrange
      final bloc = _blocWith(courses: [
        _courseWith(id: 'englisch', name: 'Englisch', isSelected: false),
        _courseWith(id: 'deutsch', name: 'Deutsch', isSelected: false),
        _courseWith(id: 'franzosisch', name: 'Französisch', isSelected: true),
        _courseWith(id: 'spanisch', name: 'Spanisch', isSelected: true),
      ]);
      // Act
      bloc.setSelectionState(_groupKeyOfCourse('englisch'), true);
      bloc.setSelectionState(_groupKeyOfCourse('franzosisch'), false);
      bloc.submit();
      // Assert

      // "deutsch" ist nicht drinnen, weil es vorher schon nicht selected
      // war und "franzosisch" nicht, weil es manuell von true auf false gesetzt
      // wurde.
      // Somit wird der Nutzern nur den Kursen englisch und spanisch beitreten.

      // da hier keine genaue Sportierung erforderlich ist, wird unorderedEquals verwendet.
      expect(mockGroupJoinBloc.sentCourseIds,
          unorderedEquals(['englisch', 'spanisch']));
    });

    test(
        'sends new request with all preselected courses, if users skips the selection',
        () async {
      // Arrange
      final bloc = _blocWith(courses: [
        _courseWith(id: 'englisch', name: 'Englisch', isSelected: true),
        _courseWith(id: 'deutsch', name: 'Deutsch', isSelected: false),
        _courseWith(id: 'franzosisch', name: 'Französisch', isSelected: true),
      ]);

      bloc.setSelectionState(_groupKeyOfCourse('englisch'), false);

      // Act
      bloc.skip();

      // Assert
      // da hier keine genaue Sportierung erforderlich ist, wird unorderedEquals verwendet.
      expect(mockGroupJoinBloc.sentCourseIds,
          unorderedEquals(['englisch', 'franzosisch']));
    });
  });
}

extension on Stream<List<GroupInfoWithSelectionState>> {
  Future<GroupInfoWithSelectionState> withCourse({@required String id}) async {
    return (await first).firstWhere((groupInfo) => groupInfo.id == id);
  }
}
