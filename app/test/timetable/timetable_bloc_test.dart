// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/src/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_view.dart';
import 'package:test_randomness/test_randomness.dart';
import 'package:time/time.dart';

import 'mock/mock_course_gateway.dart';
import 'mock/mock_school_class_filter_analytics.dart';
import 'mock/mock_school_class_gateway.dart';
import 'mock/mock_timetable_gateway.dart';
import 'mock/mock_user_gateway.dart';

void main() {
  group('TimetableBloc', () {
    SchoolClass createSchoolClass(String id) {
      final data = {
        'name': id,
        'myRole': 'standard',
        'publicKey': '123456',
        'joinLink': 'https://sharez.one/RpvEuUZMLEjb522N8',
        'personalSharecode': '654321',
        'personalJoinLink': 'https://sharez.one/RpvEuUZMLEjb522N7',
        'settings': null,
      };

      return SchoolClass.fromData(data, id: id);
    }

    Lesson createLesson(String groupId) {
      return Lesson(
        createdOn: DateTime(2024, 1, 1),
        startTime: Time(hour: 9, minute: 0),
        endTime: Time(hour: 10, minute: 0),
        groupID: groupId,
        groupType: GroupType.course,
        lessonID: szTestRandom.nextInt(200).toString(),
        place: "",
        teacher: "",
        weekday: WeekDay.monday,
        weektype: WeekType.always,
        startDate: Date.fromDateTime(clock.now()),
        endDate: Date.fromDateTime(clock.now()),
      );
    }

    CalendricalEvent createEvent(String groupId) {
      return CalendricalEvent(
        createdOn: DateTime(2021, 1, 1),
        startTime: Time(hour: 9, minute: 0),
        endTime: Time(hour: 10, minute: 0),
        groupID: groupId,
        groupType: GroupType.course,
        place: "",
        authorID: 'authorId',
        date: Date.today(),
        detail: '',
        eventID: 'eventId',
        eventType: EventType.event,
        latestEditor: '',
        sendNotification: false,
        title: 'title',
      );
    }

    final klasse10a = createSchoolClass('10a');
    final klasse5b = createSchoolClass('5b');

    const mathe10aId = GroupId('mathe10a');
    const deutsch5bId = GroupId('deutsch5bId');

    // Die Informatik AG ist mit keiner Schulklasse verknüpft.
    const informatikAgId = GroupId('informatikAg');

    final lesson10a = createLesson(mathe10aId.value);
    final lesson5b = createLesson(deutsch5bId.value);
    final lessonAg = createLesson(informatikAgId.value);

    final event10a = createEvent(mathe10aId.value);
    final event5b = createEvent(deutsch5bId.value);
    final eventAg = createEvent(informatikAgId.value);

    group('SchoolClassSelection', () {
      late TimetableBloc bloc;
      late MockSchoolClassGateway schoolClassGateway;
      MockTimetableGateway timetableGateway;
      late MockSchoolClassFilterAnalytics schoolClassSelectionAnalytics;

      setUp(() {
        schoolClassGateway = MockSchoolClassGateway();
        timetableGateway = MockTimetableGateway();
        schoolClassSelectionAnalytics = MockSchoolClassFilterAnalytics();

        bloc = TimetableBloc(
          schoolClassGateway,
          MockUserGateway(),
          timetableGateway,
          MockCourseGateway(),
          schoolClassSelectionAnalytics,
        );

        schoolClassGateway.addSchoolClasses([klasse10a, klasse5b]);

        schoolClassGateway.addCourse(klasse10a.id, mathe10aId.value);
        schoolClassGateway.addCourse(klasse5b.id, deutsch5bId.value);

        timetableGateway.addLessons([lesson10a, lesson5b, lessonAg]);
        timetableGateway.addEvents([event10a, event5b, eventAg]);
      });

      test(
        'If the user has not selected a specific school class, the lessons of all groups should be shown',
        () async {
          expect(
            bloc.lessons,
            emits([lesson10a, lesson5b, lessonAg]),
            reason:
                'the user has not specified a school class, so all lessons should be shown',
          );
        },
      );

      test(
        'If the user has selected a specific school class, only the lessons of this group should be shown',
        () async {
          bloc.changeSchoolClassFilter(
            SchoolClassFilter.showSchoolClass(klasse10a.groupId),
          );

          // Wird benötigt, damit der Test funktioniert.
          await Future.delayed(const Duration(milliseconds: 1));

          expect(
            bloc.lessons,
            emits([lesson10a]),
            reason:
                'the user has specified the school class "10a", so only lessons of the 10a should be shown',
          );
        },
      );

      test(
        'If the user has selected a specific school class, the school class view should be selected',
        () {
          bloc.changeSchoolClassFilter(
            SchoolClassFilter.showSchoolClass(klasse10a.groupId),
          );

          expect(
            bloc.schoolClassFilterView.map((view) => view.schoolClassList),
            emitsInOrder([
              // Es werden alle Gruppen angezeigt (da keine spezifische Klasse
              // ausgewählt wurde)
              [
                klasse10a.toView(isSelected: false),
                klasse5b.toView(isSelected: false),
              ],
              [
                klasse10a.toView(isSelected: true),
                klasse5b.toView(isSelected: false),
              ],
            ]),
          );
        },
      );

      test('As a default value all groups should be shown', () {
        expect(
          bloc.schoolClassFilterView.valueOrNull!.shouldShowAllGroups,
          true,
        );
      });

      test(
        'If "show all groups" is selected then no specific class should be selected',
        () async {
          // Da der default-Wert ist, dass alle Gruppen gezeigt werden, müssen wir
          // als Setup erst eine spezifische Klasse auswählen.
          bloc.changeSchoolClassFilter(
            SchoolClassFilter.showSchoolClass(klasse5b.groupId),
          );
          bloc.changeSchoolClassFilter(SchoolClassFilter.showAllGroups());

          await pumpEventQueue();

          final view = bloc.schoolClassFilterView.valueOrNull!;

          /// Da keine Klasse selektiert wurde, heißt das, dass die Stunden aller
          /// Gruppen dem Nutzer angezeigt werden sollen.
          expect(view.shouldShowAllGroups, true);
          expect(view.schoolClassList, [
            klasse10a.toView(isSelected: false),
            klasse5b.toView(isSelected: false),
          ]);
        },
      );

      test(
        'If the user has not selected a specific school class, the events of all groups should be shown',
        () async {
          expect(
            bloc.events(Date.today(), endDate: Date.today()),
            emits([event10a, event5b, eventAg]),
            reason:
                'the user has not specified a school class, so all events should be shown',
          );
        },
      );

      test(
        'If the user has not selected a specific school class, the events of all groups should be shown',
        () async {
          bloc.changeSchoolClassFilter(
            SchoolClassFilter.showSchoolClass(klasse5b.groupId),
          );

          expect(
            bloc.events(Date.today(), endDate: Date.today()),
            emits([event5b]),
            reason:
                'the user has specified a school class, so only events of 5a should be shown',
          );
        },
      );

      test(
        'The school classes in the view should be sorted alphabetically',
        () async {
          final a = createSchoolClass('a');
          final b = createSchoolClass('b');
          final c = createSchoolClass('c');

          schoolClassGateway.addSchoolClasses([c, a, b]);

          // Wird benötigt, damit der Test funktioniert.
          await pumpEventQueue();

          final expectedView = SchoolClassFilterView(
            schoolClassList: [
              klasse10a.toView(),
              klasse5b.toView(),
              a.toView(),
              b.toView(),
              c.toView(),
            ],
          );
          expect(bloc.schoolClassFilterView, emits(expectedView));
        },
      );

      group('analytics', () {
        test('Log analyitcs, if the user selects a specific school class.', () {
          bloc.changeSchoolClassFilter(
            SchoolClassFilter.showSchoolClass(klasse10a.groupId),
          );

          expect(
            schoolClassSelectionAnalytics.loggedSelectedASpecificSchoolClass,
            true,
          );
          expect(
            schoolClassSelectionAnalytics.loggedSelectedToShowAllGroups,
            false,
          );
        });

        test('Log analyitcs, if the user selects a specific school class.', () {
          bloc.changeSchoolClassFilter(SchoolClassFilter.showAllGroups());

          expect(
            schoolClassSelectionAnalytics.loggedSelectedToShowAllGroups,
            true,
          );
          expect(
            schoolClassSelectionAnalytics.loggedSelectedASpecificSchoolClass,
            false,
          );
        });
      });
    });
  });
}

extension on SchoolClass {
  SchoolClassView toView({bool isSelected = false}) {
    return SchoolClassView(id: GroupId(id), name: name, isSelected: isSelected);
  }
}
