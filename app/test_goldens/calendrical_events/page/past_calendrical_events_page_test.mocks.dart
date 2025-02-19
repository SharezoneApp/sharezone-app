// Mocks generated by Mockito 5.4.5 from annotations
// in sharezone/test_goldens/calendrical_events/page/past_calendrical_events_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i15;

import 'package:clock/clock.dart' as _i6;
import 'package:date/date.dart' as _i9;
import 'package:group_domain_models/group_domain_models.dart' as _i16;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i14;
import 'package:sharezone/calendrical_events/analytics/past_calendrical_events_page_analytics.dart'
    as _i7;
import 'package:sharezone/calendrical_events/models/calendrical_event.dart'
    as _i12;
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller.dart'
    as _i8;
import 'package:sharezone/calendrical_events/provider/past_calendrical_events_page_controller_factory.dart'
    as _i13;
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart'
    as _i2;
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart'
    as _i11;
import 'package:sharezone/util/api/course_gateway.dart' as _i4;
import 'package:sharezone/util/api/school_class_gateway.dart' as _i5;
import 'package:sharezone/util/api/timetable_gateway.dart' as _i3;
import 'package:time/time.dart' as _i10;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSubscriptionService_0 extends _i1.SmartFake
    implements _i2.SubscriptionService {
  _FakeSubscriptionService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTimetableGateway_1 extends _i1.SmartFake
    implements _i3.TimetableGateway {
  _FakeTimetableGateway_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCourseGateway_2 extends _i1.SmartFake implements _i4.CourseGateway {
  _FakeCourseGateway_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSchoolClassGateway_3 extends _i1.SmartFake
    implements _i5.SchoolClassGateway {
  _FakeSchoolClassGateway_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClock_4 extends _i1.SmartFake implements _i6.Clock {
  _FakeClock_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePastCalendricalEventsPageAnalytics_5 extends _i1.SmartFake
    implements _i7.PastCalendricalEventsPageAnalytics {
  _FakePastCalendricalEventsPageAnalytics_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePastCalendricalEventsPageController_6 extends _i1.SmartFake
    implements _i8.PastCalendricalEventsPageController {
  _FakePastCalendricalEventsPageController_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDate_7 extends _i1.SmartFake implements _i9.Date {
  _FakeDate_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTime_8 extends _i1.SmartFake implements _i10.Time {
  _FakeTime_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLessonLength_9 extends _i1.SmartFake implements _i11.LessonLength {
  _FakeLessonLength_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_10 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCalendricalEvent_11 extends _i1.SmartFake
    implements _i12.CalendricalEvent {
  _FakeCalendricalEvent_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PastCalendricalEventsPageControllerFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockPastCalendricalEventsPageControllerFactory extends _i1.Mock
    implements _i13.PastCalendricalEventsPageControllerFactory {
  @override
  _i2.SubscriptionService get subscriptionService => (super.noSuchMethod(
        Invocation.getter(#subscriptionService),
        returnValue: _FakeSubscriptionService_0(
          this,
          Invocation.getter(#subscriptionService),
        ),
        returnValueForMissingStub: _FakeSubscriptionService_0(
          this,
          Invocation.getter(#subscriptionService),
        ),
      ) as _i2.SubscriptionService);

  @override
  _i3.TimetableGateway get timetableGateway => (super.noSuchMethod(
        Invocation.getter(#timetableGateway),
        returnValue: _FakeTimetableGateway_1(
          this,
          Invocation.getter(#timetableGateway),
        ),
        returnValueForMissingStub: _FakeTimetableGateway_1(
          this,
          Invocation.getter(#timetableGateway),
        ),
      ) as _i3.TimetableGateway);

  @override
  _i4.CourseGateway get courseGateway => (super.noSuchMethod(
        Invocation.getter(#courseGateway),
        returnValue: _FakeCourseGateway_2(
          this,
          Invocation.getter(#courseGateway),
        ),
        returnValueForMissingStub: _FakeCourseGateway_2(
          this,
          Invocation.getter(#courseGateway),
        ),
      ) as _i4.CourseGateway);

  @override
  _i5.SchoolClassGateway get schoolClassGateway => (super.noSuchMethod(
        Invocation.getter(#schoolClassGateway),
        returnValue: _FakeSchoolClassGateway_3(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
        returnValueForMissingStub: _FakeSchoolClassGateway_3(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
      ) as _i5.SchoolClassGateway);

  @override
  _i6.Clock get clock => (super.noSuchMethod(
        Invocation.getter(#clock),
        returnValue: _FakeClock_4(
          this,
          Invocation.getter(#clock),
        ),
        returnValueForMissingStub: _FakeClock_4(
          this,
          Invocation.getter(#clock),
        ),
      ) as _i6.Clock);

  @override
  _i7.PastCalendricalEventsPageAnalytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakePastCalendricalEventsPageAnalytics_5(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakePastCalendricalEventsPageAnalytics_5(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i7.PastCalendricalEventsPageAnalytics);

  @override
  _i8.PastCalendricalEventsPageController create() => (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
        ),
        returnValue: _FakePastCalendricalEventsPageController_6(
          this,
          Invocation.method(
            #create,
            [],
          ),
        ),
        returnValueForMissingStub: _FakePastCalendricalEventsPageController_6(
          this,
          Invocation.method(
            #create,
            [],
          ),
        ),
      ) as _i8.PastCalendricalEventsPageController);
}

/// A class which mocks [PastCalendricalEventsPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockPastCalendricalEventsPageController extends _i1.Mock
    implements _i8.PastCalendricalEventsPageController {
  @override
  _i8.PastCalendricalEventsPageState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i14.dummyValue<_i8.PastCalendricalEventsPageState>(
          this,
          Invocation.getter(#state),
        ),
        returnValueForMissingStub:
            _i14.dummyValue<_i8.PastCalendricalEventsPageState>(
          this,
          Invocation.getter(#state),
        ),
      ) as _i8.PastCalendricalEventsPageState);

  @override
  set state(_i8.PastCalendricalEventsPageState? _state) => super.noSuchMethod(
        Invocation.setter(
          #state,
          _state,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.TimetableGateway get timetableGateway => (super.noSuchMethod(
        Invocation.getter(#timetableGateway),
        returnValue: _FakeTimetableGateway_1(
          this,
          Invocation.getter(#timetableGateway),
        ),
        returnValueForMissingStub: _FakeTimetableGateway_1(
          this,
          Invocation.getter(#timetableGateway),
        ),
      ) as _i3.TimetableGateway);

  @override
  _i4.CourseGateway get courseGateway => (super.noSuchMethod(
        Invocation.getter(#courseGateway),
        returnValue: _FakeCourseGateway_2(
          this,
          Invocation.getter(#courseGateway),
        ),
        returnValueForMissingStub: _FakeCourseGateway_2(
          this,
          Invocation.getter(#courseGateway),
        ),
      ) as _i4.CourseGateway);

  @override
  _i5.SchoolClassGateway get schoolClassGateway => (super.noSuchMethod(
        Invocation.getter(#schoolClassGateway),
        returnValue: _FakeSchoolClassGateway_3(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
        returnValueForMissingStub: _FakeSchoolClassGateway_3(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
      ) as _i5.SchoolClassGateway);

  @override
  _i7.PastCalendricalEventsPageAnalytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakePastCalendricalEventsPageAnalytics_5(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakePastCalendricalEventsPageAnalytics_5(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i7.PastCalendricalEventsPageAnalytics);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void setSortOrder(_i8.EventsSortingOrder? order) => super.noSuchMethod(
        Invocation.method(
          #setSortOrder,
          [order],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i15.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i15.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CalendricalEvent].
///
/// See the documentation for Mockito's code generation for more information.
class MockCalendricalEvent extends _i1.Mock implements _i12.CalendricalEvent {
  @override
  String get eventID => (super.noSuchMethod(
        Invocation.getter(#eventID),
        returnValue: _i14.dummyValue<String>(
          this,
          Invocation.getter(#eventID),
        ),
        returnValueForMissingStub: _i14.dummyValue<String>(
          this,
          Invocation.getter(#eventID),
        ),
      ) as String);

  @override
  String get groupID => (super.noSuchMethod(
        Invocation.getter(#groupID),
        returnValue: _i14.dummyValue<String>(
          this,
          Invocation.getter(#groupID),
        ),
        returnValueForMissingStub: _i14.dummyValue<String>(
          this,
          Invocation.getter(#groupID),
        ),
      ) as String);

  @override
  String get authorID => (super.noSuchMethod(
        Invocation.getter(#authorID),
        returnValue: _i14.dummyValue<String>(
          this,
          Invocation.getter(#authorID),
        ),
        returnValueForMissingStub: _i14.dummyValue<String>(
          this,
          Invocation.getter(#authorID),
        ),
      ) as String);

  @override
  _i16.GroupType get groupType => (super.noSuchMethod(
        Invocation.getter(#groupType),
        returnValue: _i16.GroupType.course,
        returnValueForMissingStub: _i16.GroupType.course,
      ) as _i16.GroupType);

  @override
  _i12.EventType get eventType => (super.noSuchMethod(
        Invocation.getter(#eventType),
        returnValue: _i12.EventType.event,
        returnValueForMissingStub: _i12.EventType.event,
      ) as _i12.EventType);

  @override
  _i9.Date get date => (super.noSuchMethod(
        Invocation.getter(#date),
        returnValue: _FakeDate_7(
          this,
          Invocation.getter(#date),
        ),
        returnValueForMissingStub: _FakeDate_7(
          this,
          Invocation.getter(#date),
        ),
      ) as _i9.Date);

  @override
  _i10.Time get startTime => (super.noSuchMethod(
        Invocation.getter(#startTime),
        returnValue: _FakeTime_8(
          this,
          Invocation.getter(#startTime),
        ),
        returnValueForMissingStub: _FakeTime_8(
          this,
          Invocation.getter(#startTime),
        ),
      ) as _i10.Time);

  @override
  _i10.Time get endTime => (super.noSuchMethod(
        Invocation.getter(#endTime),
        returnValue: _FakeTime_8(
          this,
          Invocation.getter(#endTime),
        ),
        returnValueForMissingStub: _FakeTime_8(
          this,
          Invocation.getter(#endTime),
        ),
      ) as _i10.Time);

  @override
  String get title => (super.noSuchMethod(
        Invocation.getter(#title),
        returnValue: _i14.dummyValue<String>(
          this,
          Invocation.getter(#title),
        ),
        returnValueForMissingStub: _i14.dummyValue<String>(
          this,
          Invocation.getter(#title),
        ),
      ) as String);

  @override
  bool get sendNotification => (super.noSuchMethod(
        Invocation.getter(#sendNotification),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i11.LessonLength get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: _FakeLessonLength_9(
          this,
          Invocation.getter(#length),
        ),
        returnValueForMissingStub: _FakeLessonLength_9(
          this,
          Invocation.getter(#length),
        ),
      ) as _i11.LessonLength);

  @override
  DateTime get startDateTime => (super.noSuchMethod(
        Invocation.getter(#startDateTime),
        returnValue: _FakeDateTime_10(
          this,
          Invocation.getter(#startDateTime),
        ),
        returnValueForMissingStub: _FakeDateTime_10(
          this,
          Invocation.getter(#startDateTime),
        ),
      ) as DateTime);

  @override
  DateTime get endDateTime => (super.noSuchMethod(
        Invocation.getter(#endDateTime),
        returnValue: _FakeDateTime_10(
          this,
          Invocation.getter(#endDateTime),
        ),
        returnValueForMissingStub: _FakeDateTime_10(
          this,
          Invocation.getter(#endDateTime),
        ),
      ) as DateTime);

  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: <String, dynamic>{},
        returnValueForMissingStub: <String, dynamic>{},
      ) as Map<String, dynamic>);

  @override
  _i12.CalendricalEvent copyWith({
    String? eventID,
    String? groupID,
    String? authorID,
    _i16.GroupType? groupType,
    _i12.EventType? eventType,
    _i9.Date? date,
    _i10.Time? startTime,
    _i10.Time? endTime,
    String? title,
    String? detail,
    String? place,
    bool? sendNotification,
    String? latestEditor,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #copyWith,
          [],
          {
            #eventID: eventID,
            #groupID: groupID,
            #authorID: authorID,
            #groupType: groupType,
            #eventType: eventType,
            #date: date,
            #startTime: startTime,
            #endTime: endTime,
            #title: title,
            #detail: detail,
            #place: place,
            #sendNotification: sendNotification,
            #latestEditor: latestEditor,
          },
        ),
        returnValue: _FakeCalendricalEvent_11(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #eventID: eventID,
              #groupID: groupID,
              #authorID: authorID,
              #groupType: groupType,
              #eventType: eventType,
              #date: date,
              #startTime: startTime,
              #endTime: endTime,
              #title: title,
              #detail: detail,
              #place: place,
              #sendNotification: sendNotification,
              #latestEditor: latestEditor,
            },
          ),
        ),
        returnValueForMissingStub: _FakeCalendricalEvent_11(
          this,
          Invocation.method(
            #copyWith,
            [],
            {
              #eventID: eventID,
              #groupID: groupID,
              #authorID: authorID,
              #groupType: groupType,
              #eventType: eventType,
              #date: date,
              #startTime: startTime,
              #endTime: endTime,
              #title: title,
              #detail: detail,
              #place: place,
              #sendNotification: sendNotification,
              #latestEditor: latestEditor,
            },
          ),
        ),
      ) as _i12.CalendricalEvent);
}
