// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:date/weektype.dart';
import 'package:flutter/widgets.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/lesson_data_snapshot.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_analytics.dart';
import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_view.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

class SchoolClassFilter {
  SchoolClassFilter.showAllGroups() : classIdToFilterBy = null;
  SchoolClassFilter.showSchoolClass(GroupId classId)
      // ignore: prefer_initializing_formals
      : classIdToFilterBy = classId {
    ArgumentError.notNull('SchoolClassId');
  }

  final GroupId classIdToFilterBy;
  bool get shouldFilterForClass => classIdToFilterBy != null;
}

class TimetableBloc extends BlocBase {
  final SchoolClassGateway schoolClassGateway;
  final UserGateway userGateway;
  final TimetableGateway timetableGateway;
  final CourseGateway courseGateway;
  final SchoolClassFilterAnalytics schoolClassFilterAnalytics;

  TimetableBloc(
    this.schoolClassGateway,
    this.userGateway,
    this.timetableGateway,
    this.courseGateway,
    this.schoolClassFilterAnalytics,
  ) {
    _initialiseSchoolClassFilterView();
    _initialiseLessons();
  }

  final _subscriptions = <StreamSubscription>[];

  void _initialiseSchoolClassFilterView() {
    final schoolClassStream = schoolClassGateway.stream();

    final Stream<SchoolClassFilterView> viewStream = Rx.combineLatest2<
            List<SchoolClass>, SchoolClassFilter, SchoolClassFilterView>(
        schoolClassStream, _selectedSchoolOptionSubject,
        (schoolClasses, schoolClassFilter) {
      if (!_hasSchoolClasses(schoolClasses)) {
        return SchoolClassFilterView(schoolClassList: []);
      }

      final views = schoolClasses.map((schoolClass) {
        return SchoolClassView(
          id: schoolClass.groupId,
          name: schoolClass.name,
          isSelected: (schoolClassFilter.shouldFilterForClass &&
                  schoolClass.groupId == schoolClassFilter.classIdToFilterBy) ||
              false,
        );
      }).toList();

      views.sortAlphabetically();

      return SchoolClassFilterView(schoolClassList: views);
    }).distinct();

    _subscriptions
        .add(viewStream.listen(_schoolClassFilterViewSubject.sink.add));
  }

  bool _hasSchoolClasses(List<SchoolClass> schoolClasses) {
    return schoolClasses != null;
  }

  /// Gibt die Schulstunden zurück, die dem Nutzer angezeigt werden. Falls der
  /// Nutzer eine Schulklasse ausgewählt hat, werden nur die Stunden der Kurse
  /// der Schulklasse geladen.
  void _initialiseLessons() {
    final lessonsStream = timetableGateway.streamLessons();
    final coursesOfSchoolClass = _getCourseIdOfSelectedSchoolClass();

    final Stream<List<Lesson>> filteredLessonsStream = Rx.combineLatest3<
            List<Lesson>, List<String>, SchoolClassFilter, List<Lesson>>(
        lessonsStream, coursesOfSchoolClass, _selectedSchoolOptionSubject,
        (lessons, coursesOfSchoolClass, schoolClassFilter) {
      if (schoolClassFilter.shouldFilterForClass) {
        lessons = _getLessonsOfASchoolClass(coursesOfSchoolClass, lessons);
      }

      return lessons;
    });

    _subscriptions.add(filteredLessonsStream.listen(_lessonsSubject.sink.add));
  }

  final _schoolClassFilterViewSubject =
      BehaviorSubject<SchoolClassFilterView>();

  final _lessonsSubject = BehaviorSubject<List<Lesson>>();

  final _selectedSchoolOptionSubject =
      BehaviorSubject.seeded(SchoolClassFilter.showAllGroups());

  Function(SchoolClassFilter) get changeSchoolClassFilter => (option) {
        logSchoolClassFilter(option);
        return _selectedSchoolOptionSubject.add(option);
      };

  void logSchoolClassFilter(SchoolClassFilter schoolClassFilter) {
    if (schoolClassFilter.shouldFilterForClass) {
      schoolClassFilterAnalytics.logFilterBySchoolClass();
    } else {
      schoolClassFilterAnalytics.logShowAllGroups();
    }
  }

  TimetableConfig get current =>
      TimetableConfig(userGateway.data?.userSettings);

  Stream<TimetableConfig> get stream =>
      userGateway.userStream.map((user) => TimetableConfig(user?.userSettings));

  ValueStream<SchoolClassFilterView> get schoolClassFilterView =>
      _schoolClassFilterViewSubject;

  ValueStream<List<Lesson>> get lessons => _lessonsSubject;

  /// Gibt die Termine zurück, die dem Nutzer angezeigt werden. Falls der
  /// Nutzer eine Schulklasse ausgewählt hat, werden nur die Termine der Kurse
  /// der Schulklasse geladen.
  Stream<List<CalendricalEvent>> events(Date startDate, {Date endDate}) {
    /// Der Stream kann hier nicht direkt zurückgegeben werden, falls keine
    /// Klasse ausgewählt wurde (also alle Stunden angezeigt werden sollen),
    /// da nachträglich der Filter geändert werden kann (dass nur die Stunden
    /// einer spezifischen Klasse angezeigt werden soll).
    final eventsStream = timetableGateway.streamEvents(startDate, endDate);
    // Ist leer, wenn keine Klasse ausgewählt wurde
    final coursesOfSchoolClass = _getCourseIdOfSelectedSchoolClass();

    return Rx.combineLatest3<List<CalendricalEvent>, List<String>,
            SchoolClassFilter, List<CalendricalEvent>>(
        eventsStream, coursesOfSchoolClass, _selectedSchoolOptionSubject,
        (events, coursesOfSchoolClass, selectedSchoolClass) {
      if (selectedSchoolClass.shouldFilterForClass) {
        events = events
            .where((event) => coursesOfSchoolClass.contains(event.groupID))
            .toList();
      }

      return events;
    });
  }

  // Falls keine Schulklasse ausgewählt wurde, wird eine leere Liste
  // zurückgegeben.
  Stream<List<String>> _getCourseIdOfSelectedSchoolClass() {
    return _selectedSchoolOptionSubject.flatMap((option) =>
        option.shouldFilterForClass
            ? schoolClassGateway.streamCoursesID('${option.classIdToFilterBy}')
            : Stream.value(<String>[]));
  }

  List<Lesson> _getLessonsOfASchoolClass(
      List<String> courseIdsOfSchoolClass, List<Lesson> allLessons) {
    return allLessons
        .where((lesson) => courseIdsOfSchoolClass.contains(lesson.groupID))
        .toList();
  }

  /// Diese Methode wird für die Dashboard-Page verwendet, um die Stunden von dem heutigen Tag zu laden.
  Stream<LessonDataSnapshot> streamLessonsForDate(Date date) {
    final unFilteredLessonsStream =
        timetableGateway.streamLessonsUnfilteredForDate(date);
    final groupInfoStream =
        courseGateway.getGroupInfoStream(schoolClassGateway);

    final streamGroup = CombineLatestStream(
        [stream, unFilteredLessonsStream, groupInfoStream], (streamValues) {
      TimetableConfig config = streamValues[0] as TimetableConfig ?? current;
      List<Lesson> lessons = streamValues[1] as List<Lesson> ?? [];
      Map<String, GroupInfo> groupInfos =
          streamValues[2] as Map<String, GroupInfo> ?? {};
      final weekType = config.getWeekType(date);
      return LessonDataSnapshot(
        lessons: getFilteredLessonList(lessons, weekType),
        groupInfos: groupInfos,
      );
    });
    return streamGroup;
  }

  @override
  void dispose() {
    _selectedSchoolOptionSubject.close();
    _schoolClassFilterViewSubject.close();
    _lessonsSubject.close();
    _subscriptions.forEach((element) => element.cancel());
  }
}

List<Lesson> getFilteredLessonList(List<Lesson> lessons, WeekType weekType) {
  return lessons.where((lesson) {
    // ONLY ADD LESSON IF MATCHES SAME WEEKTYPE OR IS ALWAYS ACTIVE
    if (weekType == WeekType.always) return true;
    if (lesson.weektype == WeekType.always) return true;
    return lesson.weektype == weekType;
  }).toList();
}

class TimetableConfig {
  final UserSettings _userSettings;
  TimetableConfig(this._userSettings);

  UserSettings _getUserSettings() {
    return _userSettings ?? UserSettings.defaultSettings();
  }

  WeekType getWeekType(Date date) {
    return !_getUserSettings().isABWeekEnabled
        ? WeekType.always
        : _getWeekTypeOfDate(date);
  }

  WeekType _getWeekTypeOfDate(Date date) {
    bool isAWeekEvenWeek = _getUserSettings().isAWeekEvenWeek;
    if (_isCurrentWeekEven(date)) {
      return isAWeekEvenWeek ? WeekType.a : WeekType.b;
    } else {
      return isAWeekEvenWeek ? WeekType.b : WeekType.a;
    }
  }

  bool _isCurrentWeekEven(Date date) {
    return _getCurrentWeekNumber(date).isEven;
  }

  int _getCurrentWeekNumber(Date date) {
    return date.weekNumber;
  }

  bool isABWeekEnabled() {
    return _getUserSettings().isABWeekEnabled;
  }

  bool showAbbreviation() {
    return _getUserSettings().showAbbreviation;
  }

  Time getTimetableStartTime() {
    return _getUserSettings().timetableStartTime;
  }

  Periods getPeriods() {
    return _getUserSettings().periods;
  }

  EnabledWeekDays getEnabledWeekDays() {
    return _getUserSettings().enabledWeekDays;
  }

  double get timetableScale => 1;
}

class TimetableConfigBloc extends BlocBase {
  final TimetableConfig config;
  TimetableConfigBloc(this.config);

  @override
  void dispose() {}
}

class TimetableConfigBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, TimetableConfig config) builder;

  const TimetableConfigBuilder({Key key, @required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    return StreamBuilder<TimetableConfig>(
      initialData: timetableBloc.current,
      stream: timetableBloc.stream,
      builder: (context, snapshot) {
        return BlocProvider<TimetableConfigBloc>(
          bloc: TimetableConfigBloc(snapshot.data),
          child: builder(context, snapshot.data),
        );
      },
    );
  }
}

extension on List<SchoolClassView> {
  void sortAlphabetically() {
    // Es wird .toLowerCase() verwendet, da ansonsten erst die Schulklasse mit
    // einem großen Anfangsbuchstaben gelistet werden und danach mit einem
    // kleinen, also ABCabc. Jedoch soll dies egal sein, ob der Anfangsbuchstabe
    // groß oder klein geschrieben wird, also AaBbCc.
    return sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
