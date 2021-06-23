import 'dart:async';
import 'package:bloc_base/bloc_base.dart';
import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/models/homework_view.dart';
import 'package:sharezone/dashboard/timetable/lesson_view.dart';
import 'package:date/date.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/models/blackboard_item.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/lesson_data_snapshot.dart';
import 'package:sharezone/timetable/src/widgets/events/event_view.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/api/schoolClassGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_utils/streams.dart';
import 'package:sharezone/widgets/blackboard/blackboard_view.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

import '../gateway/dashboard_gateway.dart';

part 'build_lesson_views.dart';
part 'current_lesson_index.dart';

extension RepeatEveryExtension<T> on Stream<T> {
  /// Gibt die letzen/neuesten Daten des Streams jede [duration] zurück.
  Stream<T> repeatEvery(Duration duration) {
    return Rx.combineLatest2<T, void, T>(
      this,
      Stream<void>.periodic(duration),
      (value, _) => value,
    );
  }
}

class DashboardBloc extends BlocBase {
  final String _uid;
  final todayDateTimeWithoutTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final _unreadBlackboardViewsSubject = BehaviorSubject<List<BlackboardView>>();
  final _unreadBlackboardItemsEmptySubject = BehaviorSubject<bool>();
  final _urgentHomeworksSubject = BehaviorSubject<List<HomeworkView>>();
  final _urgentHomeworksEmptySubject = BehaviorSubject<bool>();
  final _upcomingEventsSubject = BehaviorSubject<List<EventView>>();
  final _numberOfUrgentHomeworksSubject = BehaviorSubject<int>();
  final _numberOfUnreadBlackboardViewsSubject = BehaviorSubject<int>();
  final _nubmerOfUpcomingEventsSubject = BehaviorSubject<int>();
  final _lessonViewsSubject = BehaviorSubject<List<LessonView>>();

  Stream<List<HomeworkView>> get urgentHomeworks => _urgentHomeworksSubject;
  Stream<List<BlackboardView>> get unreadBlackboardViews =>
      _unreadBlackboardViewsSubject;
  Stream<bool> get urgentHomeworksEmpty => _urgentHomeworksEmptySubject;
  Stream<List<EventView>> get upcomingEvents => _upcomingEventsSubject;
  Stream<int> get numberOfUrgentHomeworks => _numberOfUrgentHomeworksSubject;
  Stream<List<LessonView>> get lessonViews => _lessonViewsSubject;
  Stream<int> get numberOfUnreadBlackboardViews =>
      _numberOfUnreadBlackboardViewsSubject;
  Stream<bool> get unreadBlackboardViewsEmpty =>
      _unreadBlackboardItemsEmptySubject;
  Stream<int> get nubmerOfUpcomingEvents => _nubmerOfUpcomingEventsSubject;

  final _subscriptions = <StreamSubscription>[];

  DashboardBloc(
      this._uid, DashboardGateway gateway, TimetableBloc timetableBloc) {
    _initialiseUrgentHomeworks(
        gateway.homeworkGateway, gateway.courseGateway, gateway.userGateway);
    _initialiseUnreadBlackboardViews(
        gateway.blackboardGateway, gateway.courseGateway);
    _initialiseUpcomingEvents(gateway.timetableGateway, gateway.courseGateway,
        gateway.schoolClassGateway);
    _initialiseLessonViewStream(timetableBloc);
  }

  void _initialiseLessonViewStream(TimetableBloc timetableBloc) {
    // Durch das periodische Aktualisieren des aktuellen Tages bleibt die Seite
    // immer aktuell.
    // Ansonsten werden alte Daten angezeigt, wenn man die App am nächsten Tag
    // aus dem Hintergrund öffnet.
    final periodicUpdatingLessonSnapshotStream =
        Date.streamToday().flatMap(timetableBloc.streamLessonsForDate);

    final viewsStream = periodicUpdatingLessonSnapshotStream
        // Die Views werden jede Sekunde neu gebaut, damit der "Ablauf" der
        // Stunde in Echtzeit angezeigt wird (ausfaden der Stunden).
        .repeatEvery(const Duration(seconds: 1))
        .map(_buildSortedViews);

    final subscription = viewsStream.listen(_lessonViewsSubject.add);

    _subscriptions.add(subscription);
  }

  void _initialiseUrgentHomeworks(HomeworkGateway homeworkGateway,
      CourseGateway courseGateway, UserGateway userGateway) {
    TwoStreams<List<HomeworkDto>, AppUser>(
            homeworkGateway.homeworkForNowAndInFutureStream,
            userGateway.userStream)
        .stream
        .listen((result) {
      final homeworkList = result.data0;
      final user = result.data1;

      final urgentHomeworks = _filterUrgentHomeworks(
          homeworkList, user?.typeOfUser ?? TypeOfUser.student);
      final urgentHomeworkViews =
          _mapHomeworksIntoHomeworkViews(urgentHomeworks, courseGateway);

      _sortUrgentHomeworksByTodoUntilAndCourseName(urgentHomeworkViews);

      final isUrgentHomeworksEmpty = urgentHomeworks.isEmpty;
      _isSubjectListEmpty(isUrgentHomeworksEmpty, _urgentHomeworksEmptySubject);

      _numberOfUrgentHomeworksSubject.sink.add(urgentHomeworkViews.length);
      _urgentHomeworksSubject.sink.add(urgentHomeworkViews);
    });
  }

  void _sortUrgentHomeworksByTodoUntilAndCourseName(
      List<HomeworkView> urgentHomeworkViews) {
    urgentHomeworkViews.sort((a, b) {
      final r = a.homework.todoUntil.compareTo(b.homework.todoUntil);
      if (r != 0) return r;
      return a.courseName.compareTo(b.courseName);
    });
  }

  List<HomeworkView> _mapHomeworksIntoHomeworkViews(
      List<HomeworkDto> urgentHomeworks, CourseGateway courseGateway) {
    return urgentHomeworks
        .map((homework) => HomeworkView.fromHomework(homework, courseGateway))
        .toList();
  }

  List<HomeworkDto> _filterUrgentHomeworks(
      List<HomeworkDto> allHomeworks, TypeOfUser typeOfUser) {
    final now = DateTime.now();
    final dayAfterTomorrow = DateTime(now.year, now.month, now.day + 2);
    // Was passiert, wenn der 30. Oktober ist und 2 Tage dazu gezählt werden? Springt es dann auf den 1. November um?
    // Antwort: Springt um auf den 1.November, gechekt, auf wenn der Code unschön ist, besser wäre dayAfterTomorrow = now.add(Duration(days:2))

    if (typeOfUser == TypeOfUser.student)
      return allHomeworks
          .where((homework) =>
              homework.forUsers[_uid] == false &&
              homework.todoUntil.isBefore(dayAfterTomorrow))
          .toList();

    // Für Eltern und Lehrkräfe nicht beachten, ob die HA gemacht wurde oder nicht.
    return allHomeworks.where((homework) {
      final date = homework.todoUntil;
      return date.isToday || date.isTomorrow || date.isDayAfterTomorrow;
    }).toList();
  }

  void _initialiseUnreadBlackboardViews(
      BlackboardGateway gateway, CourseGateway courseGateway) {
    gateway.blackboardItemStream.listen((blackboardItems) {
      final unreadBlackboardItems = blackboardItems
          .where(
              (item) => item.forUsers[_uid] == false && item.authorID != _uid)
          .toList();
      final unreadBlackboardViews = _mapBlackboardItemsIntoBlackboardView(
          unreadBlackboardItems, courseGateway);

      final isUnreadBlackboardItemsEmpty = unreadBlackboardViews.isEmpty;
      _isSubjectListEmpty(
          isUnreadBlackboardItemsEmpty, _unreadBlackboardItemsEmptySubject);

      _numberOfUnreadBlackboardViewsSubject.sink
          .add(unreadBlackboardViews.length);
      _unreadBlackboardViewsSubject.sink.add(unreadBlackboardViews);
    });
  }

  List<BlackboardView> _mapBlackboardItemsIntoBlackboardView(
      List<BlackboardItem> unreadBlackboardItems, CourseGateway courseGateway) {
    return unreadBlackboardItems
        .map((item) =>
            BlackboardView.fromBlackboardItem(item, _uid, courseGateway))
        .toList();
  }

  void _initialiseUpcomingEvents(TimetableGateway timetablegGateway,
      CourseGateway courseGateway, SchoolClassGateway schoolClassGateway) {
    final eventStream = timetablegGateway.streamEvents(
        Date.fromDateTime(todayDateTimeWithoutTime),
        Date.fromDateTime(todayDateTimeWithoutTime.add(Duration(days: 14))));
    final groupInfoStream =
        courseGateway.getGroupInfoStream(schoolClassGateway);

    final stream =
        CombineLatestStream([eventStream, groupInfoStream], (streamValues) {
      List<CalendricalEvent> events = streamValues[0] ?? [];
      Map<String, GroupInfo> groupInfos = streamValues[1] ?? {};

      _sortEventsByDateTime(events);

      final eventViews = events
          .map((event) =>
              EventView.fromEventAndGroupInfo(event, groupInfos[event.groupID]))
          .toList();

      if (eventViews != null)
        _nubmerOfUpcomingEventsSubject.sink.add(eventViews.length);

      return eventViews;
    });

    _subscriptions
        .add(stream.listen((newData) => _upcomingEventsSubject.add(newData)));
  }

  void _sortEventsByDateTime(List<CalendricalEvent> events) {
    events.sort((a, b) {
      final r = a.date.toDateTime.compareTo(b.date.toDateTime);
      if (r != 0) return r;
      return a.startTime.compareTo(b.startTime);
    });
  }

  void _isSubjectListEmpty(bool isListEmpty, BehaviorSubject<bool> subject) {
    // Wird der Bloc das erste mal aufgerufen und die Liste ist leer, soll
    // dies SOFORT zum [_urgentHomeworksEmptySubject] hinzufügt werden. Ist
    // dies nicht der Fall, soll überprüft werden, ob die Liste leer ist. Falls
    // nicht, soll dies ebenfalls SOFORT zum [_urgentHomeworksEmptySubject]
    // hinzufügt werden. Ist die Liste leer, dies NICHT sofort übergeben werden.
    // Das den folgenden Grund, dass die letze Homework Card noch ausanimiert muss.
    // Würde sofort dem Stream übergeben, dass dieser leer ist, könnte die letzte
    // Hausaufgabe nicht ausanimiert werden.
    if (subject.value != isListEmpty) {
      if (subject.value == null && isListEmpty) {
        subject.sink.add(true);
      } else {
        if (isListEmpty) {
          // Verzögere, um letzte Element auszuanimieren
          Future.delayed(const Duration(milliseconds: 1500)).then((_) {
            subject.sink.add(true);
          });
        } else {
          subject.sink.add(false);
        }
      }
    }
  }

  @override
  void dispose() {
    _unreadBlackboardViewsSubject.close();
    _urgentHomeworksSubject.close();
    _upcomingEventsSubject.close();
    _numberOfUrgentHomeworksSubject.close();
    _urgentHomeworksEmptySubject.close();
    _numberOfUnreadBlackboardViewsSubject.close();
    _unreadBlackboardItemsEmptySubject.close();
    _lessonViewsSubject.close();
    _nubmerOfUpcomingEventsSubject.close();
    for (final listener in _subscriptions) {
      listener.cancel();
    }
  }
}

extension on DateTime {
  bool get isToday => today == withoutTime;
  bool get isTomorrow => tomorrow == withoutTime;
  bool get isDayAfterTomorrow => dayAfterTomorrow == withoutTime;

  static DateTime get today =>
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static DateTime get tomorrow =>
      DateTime(today.year, today.month, today.day + 1);
  static DateTime get dayAfterTomorrow =>
      DateTime(today.year, today.month, today.day + 2);

  DateTime get withoutTime => DateTime(year, month, day);
}
