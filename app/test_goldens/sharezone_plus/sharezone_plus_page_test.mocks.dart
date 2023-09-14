// Mocks generated by Mockito 5.4.2 from annotations
// in sharezone/test_goldens/sharezone_plus/sharezone_plus_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i22;
import 'dart:ui' as _i23;

import 'package:analytics/analytics.dart' as _i5;
import 'package:app_functions/app_functions.dart' as _i20;
import 'package:authentification_base/authentification.dart' as _i30;
import 'package:cloud_firestore/cloud_firestore.dart' as _i31;
import 'package:common_domain_models/common_domain_models.dart' as _i9;
import 'package:firebase_auth/firebase_auth.dart' as _i32;
import 'package:flutter/material.dart' as _i1;
import 'package:mockito/mockito.dart' as _i2;
import 'package:rxdart/rxdart.dart' as _i3;
import 'package:shared_preferences/shared_preferences.dart' as _i7;
import 'package:sharezone/blocs/application_bloc.dart' as _i29;
import 'package:sharezone/filesharing/file_sharing_api.dart' as _i12;
import 'package:sharezone/navigation/analytics/navigation_analytics.dart'
    as _i28;
import 'package:sharezone/navigation/logic/navigation_bloc.dart' as _i24;
import 'package:sharezone/navigation/models/navigation_item.dart' as _i25;
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_cache.dart'
    as _i26;
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/navigation_experiment/navigation_experiment_option.dart'
    as _i27;
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart'
    as _i21;
import 'package:sharezone/util/api.dart' as _i4;
import 'package:sharezone/util/api/blackboard_api.dart' as _i11;
import 'package:sharezone/util/api/connections_gateway.dart' as _i15;
import 'package:sharezone/util/api/course_gateway.dart' as _i16;
import 'package:sharezone/util/api/homework_api.dart' as _i10;
import 'package:sharezone/util/api/school_class_gateway.dart' as _i17;
import 'package:sharezone/util/api/timetable_gateway.dart' as _i18;
import 'package:sharezone/util/api/user_api.dart' as _i13;
import 'package:sharezone/util/navigation_service.dart' as _i8;
import 'package:sharezone_common/references.dart' as _i14;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart'
    as _i6;
import 'package:user/user.dart' as _i19;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGlobalKey_0<T extends _i1.State<_i1.StatefulWidget>>
    extends _i2.SmartFake implements _i1.GlobalKey<T> {
  _FakeGlobalKey_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeValueStream_1<T> extends _i2.SmartFake
    implements _i3.ValueStream<T> {
  _FakeValueStream_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSharezoneGateway_2 extends _i2.SmartFake
    implements _i4.SharezoneGateway {
  _FakeSharezoneGateway_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAnalytics_3 extends _i2.SmartFake implements _i5.Analytics {
  _FakeAnalytics_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamingSharedPreferences_4 extends _i2.SmartFake
    implements _i6.StreamingSharedPreferences {
  _FakeStreamingSharedPreferences_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSharedPreferences_5 extends _i2.SmartFake
    implements _i7.SharedPreferences {
  _FakeSharedPreferences_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeNavigationService_6 extends _i2.SmartFake
    implements _i8.NavigationService {
  _FakeNavigationService_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserId_7 extends _i2.SmartFake implements _i9.UserId {
  _FakeUserId_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeHomeworkGateway_8 extends _i2.SmartFake
    implements _i10.HomeworkGateway {
  _FakeHomeworkGateway_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBlackboardGateway_9 extends _i2.SmartFake
    implements _i11.BlackboardGateway {
  _FakeBlackboardGateway_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFileSharingGateway_10 extends _i2.SmartFake
    implements _i12.FileSharingGateway {
  _FakeFileSharingGateway_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserGateway_11 extends _i2.SmartFake implements _i13.UserGateway {
  _FakeUserGateway_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeReferences_12 extends _i2.SmartFake implements _i14.References {
  _FakeReferences_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeConnectionsGateway_13 extends _i2.SmartFake
    implements _i15.ConnectionsGateway {
  _FakeConnectionsGateway_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCourseGateway_14 extends _i2.SmartFake
    implements _i16.CourseGateway {
  _FakeCourseGateway_14(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSchoolClassGateway_15 extends _i2.SmartFake
    implements _i17.SchoolClassGateway {
  _FakeSchoolClassGateway_15(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTimetableGateway_16 extends _i2.SmartFake
    implements _i18.TimetableGateway {
  _FakeTimetableGateway_16(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAppUser_17 extends _i2.SmartFake implements _i19.AppUser {
  _FakeAppUser_17(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAppFunctionsResult_18<T> extends _i2.SmartFake
    implements _i20.AppFunctionsResult<T> {
  _FakeAppFunctionsResult_18(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SharezonePlusPageController].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharezonePlusPageController extends _i2.Mock
    implements _i21.SharezonePlusPageController {
  @override
  bool get hasPlus => (super.noSuchMethod(
        Invocation.getter(#hasPlus),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set hasPlus(bool? _hasPlus) => super.noSuchMethod(
        Invocation.setter(
          #hasPlus,
          _hasPlus,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get price => (super.noSuchMethod(
        Invocation.getter(#price),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  set price(String? _price) => super.noSuchMethod(
        Invocation.setter(
          #price,
          _price,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i22.Future<void> buySubscription() => (super.noSuchMethod(
        Invocation.method(
          #buySubscription,
          [],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> cancelSubscription() => (super.noSuchMethod(
        Invocation.method(
          #cancelSubscription,
          [],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i23.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i23.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [NavigationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationBloc extends _i2.Mock implements _i24.NavigationBloc {
  @override
  _i1.GlobalKey<_i1.State<_i1.StatefulWidget>> get scaffoldKey =>
      (super.noSuchMethod(
        Invocation.getter(#scaffoldKey),
        returnValue: _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#scaffoldKey),
        ),
        returnValueForMissingStub:
            _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#scaffoldKey),
        ),
      ) as _i1.GlobalKey<_i1.State<_i1.StatefulWidget>>);
  @override
  _i1.GlobalKey<_i1.State<_i1.StatefulWidget>> get drawerKey =>
      (super.noSuchMethod(
        Invocation.getter(#drawerKey),
        returnValue: _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#drawerKey),
        ),
        returnValueForMissingStub:
            _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#drawerKey),
        ),
      ) as _i1.GlobalKey<_i1.State<_i1.StatefulWidget>>);
  @override
  _i1.GlobalKey<_i1.State<_i1.StatefulWidget>> get controllerKey =>
      (super.noSuchMethod(
        Invocation.getter(#controllerKey),
        returnValue: _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#controllerKey),
        ),
        returnValueForMissingStub:
            _FakeGlobalKey_0<_i1.State<_i1.StatefulWidget>>(
          this,
          Invocation.getter(#controllerKey),
        ),
      ) as _i1.GlobalKey<_i1.State<_i1.StatefulWidget>>);
  @override
  _i22.Stream<_i25.NavigationItem> get currentItemStream => (super.noSuchMethod(
        Invocation.getter(#currentItemStream),
        returnValue: _i22.Stream<_i25.NavigationItem>.empty(),
        returnValueForMissingStub: _i22.Stream<_i25.NavigationItem>.empty(),
      ) as _i22.Stream<_i25.NavigationItem>);
  @override
  _i25.NavigationItem get currentItem => (super.noSuchMethod(
        Invocation.getter(#currentItem),
        returnValue: _i25.NavigationItem.overview,
        returnValueForMissingStub: _i25.NavigationItem.overview,
      ) as _i25.NavigationItem);
  @override
  dynamic Function(_i25.NavigationItem) get navigateTo => (super.noSuchMethod(
        Invocation.getter(#navigateTo),
        returnValue: (_i25.NavigationItem __p0) => null,
        returnValueForMissingStub: (_i25.NavigationItem __p0) => null,
      ) as dynamic Function(_i25.NavigationItem));
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [NavigationExperimentCache].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationExperimentCache extends _i2.Mock
    implements _i26.NavigationExperimentCache {
  @override
  _i3.ValueStream<_i27.NavigationExperimentOption> get currentNavigation =>
      (super.noSuchMethod(
        Invocation.getter(#currentNavigation),
        returnValue: _FakeValueStream_1<_i27.NavigationExperimentOption>(
          this,
          Invocation.getter(#currentNavigation),
        ),
        returnValueForMissingStub:
            _FakeValueStream_1<_i27.NavigationExperimentOption>(
          this,
          Invocation.getter(#currentNavigation),
        ),
      ) as _i3.ValueStream<_i27.NavigationExperimentOption>);
  @override
  void setNavigation(_i27.NavigationExperimentOption? option) =>
      super.noSuchMethod(
        Invocation.method(
          #setNavigation,
          [option],
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
}

/// A class which mocks [NavigationAnalytics].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationAnalytics extends _i2.Mock
    implements _i28.NavigationAnalytics {
  @override
  void logBottomNavigationBarEvent(_i25.NavigationItem? item) =>
      super.noSuchMethod(
        Invocation.method(
          #logBottomNavigationBarEvent,
          [item],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void logDrawerEvent(_i25.NavigationItem? item) => super.noSuchMethod(
        Invocation.method(
          #logDrawerEvent,
          [item],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void logUsedSwipeUpLine() => super.noSuchMethod(
        Invocation.method(
          #logUsedSwipeUpLine,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void logDrawerLogoClick() => super.noSuchMethod(
        Invocation.method(
          #logDrawerLogoClick,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void logOpenDrawer() => super.noSuchMethod(
        Invocation.method(
          #logOpenDrawer,
          [],
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
}

/// A class which mocks [SharezoneContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharezoneContext extends _i2.Mock implements _i29.SharezoneContext {
  @override
  _i4.SharezoneGateway get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeSharezoneGateway_2(
          this,
          Invocation.getter(#api),
        ),
        returnValueForMissingStub: _FakeSharezoneGateway_2(
          this,
          Invocation.getter(#api),
        ),
      ) as _i4.SharezoneGateway);
  @override
  _i5.Analytics get analytics => (super.noSuchMethod(
        Invocation.getter(#analytics),
        returnValue: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
        returnValueForMissingStub: _FakeAnalytics_3(
          this,
          Invocation.getter(#analytics),
        ),
      ) as _i5.Analytics);
  @override
  _i6.StreamingSharedPreferences get streamingSharedPreferences =>
      (super.noSuchMethod(
        Invocation.getter(#streamingSharedPreferences),
        returnValue: _FakeStreamingSharedPreferences_4(
          this,
          Invocation.getter(#streamingSharedPreferences),
        ),
        returnValueForMissingStub: _FakeStreamingSharedPreferences_4(
          this,
          Invocation.getter(#streamingSharedPreferences),
        ),
      ) as _i6.StreamingSharedPreferences);
  @override
  _i7.SharedPreferences get sharedPreferences => (super.noSuchMethod(
        Invocation.getter(#sharedPreferences),
        returnValue: _FakeSharedPreferences_5(
          this,
          Invocation.getter(#sharedPreferences),
        ),
        returnValueForMissingStub: _FakeSharedPreferences_5(
          this,
          Invocation.getter(#sharedPreferences),
        ),
      ) as _i7.SharedPreferences);
  @override
  _i8.NavigationService get navigationService => (super.noSuchMethod(
        Invocation.getter(#navigationService),
        returnValue: _FakeNavigationService_6(
          this,
          Invocation.getter(#navigationService),
        ),
        returnValueForMissingStub: _FakeNavigationService_6(
          this,
          Invocation.getter(#navigationService),
        ),
      ) as _i8.NavigationService);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [SharezoneGateway].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharezoneGateway extends _i2.Mock implements _i4.SharezoneGateway {
  @override
  String get uID => (super.noSuchMethod(
        Invocation.getter(#uID),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i9.UserId get userId => (super.noSuchMethod(
        Invocation.getter(#userId),
        returnValue: _FakeUserId_7(
          this,
          Invocation.getter(#userId),
        ),
        returnValueForMissingStub: _FakeUserId_7(
          this,
          Invocation.getter(#userId),
        ),
      ) as _i9.UserId);
  @override
  _i10.HomeworkGateway get homework => (super.noSuchMethod(
        Invocation.getter(#homework),
        returnValue: _FakeHomeworkGateway_8(
          this,
          Invocation.getter(#homework),
        ),
        returnValueForMissingStub: _FakeHomeworkGateway_8(
          this,
          Invocation.getter(#homework),
        ),
      ) as _i10.HomeworkGateway);
  @override
  _i11.BlackboardGateway get blackboard => (super.noSuchMethod(
        Invocation.getter(#blackboard),
        returnValue: _FakeBlackboardGateway_9(
          this,
          Invocation.getter(#blackboard),
        ),
        returnValueForMissingStub: _FakeBlackboardGateway_9(
          this,
          Invocation.getter(#blackboard),
        ),
      ) as _i11.BlackboardGateway);
  @override
  _i12.FileSharingGateway get fileSharing => (super.noSuchMethod(
        Invocation.getter(#fileSharing),
        returnValue: _FakeFileSharingGateway_10(
          this,
          Invocation.getter(#fileSharing),
        ),
        returnValueForMissingStub: _FakeFileSharingGateway_10(
          this,
          Invocation.getter(#fileSharing),
        ),
      ) as _i12.FileSharingGateway);
  @override
  _i13.UserGateway get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _FakeUserGateway_11(
          this,
          Invocation.getter(#user),
        ),
        returnValueForMissingStub: _FakeUserGateway_11(
          this,
          Invocation.getter(#user),
        ),
      ) as _i13.UserGateway);
  @override
  _i14.References get references => (super.noSuchMethod(
        Invocation.getter(#references),
        returnValue: _FakeReferences_12(
          this,
          Invocation.getter(#references),
        ),
        returnValueForMissingStub: _FakeReferences_12(
          this,
          Invocation.getter(#references),
        ),
      ) as _i14.References);
  @override
  String get memberID => (super.noSuchMethod(
        Invocation.getter(#memberID),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i15.ConnectionsGateway get connectionsGateway => (super.noSuchMethod(
        Invocation.getter(#connectionsGateway),
        returnValue: _FakeConnectionsGateway_13(
          this,
          Invocation.getter(#connectionsGateway),
        ),
        returnValueForMissingStub: _FakeConnectionsGateway_13(
          this,
          Invocation.getter(#connectionsGateway),
        ),
      ) as _i15.ConnectionsGateway);
  @override
  _i16.CourseGateway get course => (super.noSuchMethod(
        Invocation.getter(#course),
        returnValue: _FakeCourseGateway_14(
          this,
          Invocation.getter(#course),
        ),
        returnValueForMissingStub: _FakeCourseGateway_14(
          this,
          Invocation.getter(#course),
        ),
      ) as _i16.CourseGateway);
  @override
  _i17.SchoolClassGateway get schoolClassGateway => (super.noSuchMethod(
        Invocation.getter(#schoolClassGateway),
        returnValue: _FakeSchoolClassGateway_15(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
        returnValueForMissingStub: _FakeSchoolClassGateway_15(
          this,
          Invocation.getter(#schoolClassGateway),
        ),
      ) as _i17.SchoolClassGateway);
  @override
  _i18.TimetableGateway get timetable => (super.noSuchMethod(
        Invocation.getter(#timetable),
        returnValue: _FakeTimetableGateway_16(
          this,
          Invocation.getter(#timetable),
        ),
        returnValueForMissingStub: _FakeTimetableGateway_16(
          this,
          Invocation.getter(#timetable),
        ),
      ) as _i18.TimetableGateway);
  @override
  _i22.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
}

/// A class which mocks [UserGateway].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserGateway extends _i2.Mock implements _i13.UserGateway {
  @override
  _i14.References get references => (super.noSuchMethod(
        Invocation.getter(#references),
        returnValue: _FakeReferences_12(
          this,
          Invocation.getter(#references),
        ),
        returnValueForMissingStub: _FakeReferences_12(
          this,
          Invocation.getter(#references),
        ),
      ) as _i14.References);
  @override
  String get uID => (super.noSuchMethod(
        Invocation.getter(#uID),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  _i22.Stream<_i19.AppUser?> get userStream => (super.noSuchMethod(
        Invocation.getter(#userStream),
        returnValue: _i22.Stream<_i19.AppUser?>.empty(),
        returnValueForMissingStub: _i22.Stream<_i19.AppUser?>.empty(),
      ) as _i22.Stream<_i19.AppUser?>);
  @override
  _i22.Stream<_i30.AuthUser?> get authUserStream => (super.noSuchMethod(
        Invocation.getter(#authUserStream),
        returnValue: _i22.Stream<_i30.AuthUser?>.empty(),
        returnValueForMissingStub: _i22.Stream<_i30.AuthUser?>.empty(),
      ) as _i22.Stream<_i30.AuthUser?>);
  @override
  _i22.Stream<bool> get isSignInStream => (super.noSuchMethod(
        Invocation.getter(#isSignInStream),
        returnValue: _i22.Stream<bool>.empty(),
        returnValueForMissingStub: _i22.Stream<bool>.empty(),
      ) as _i22.Stream<bool>);
  @override
  _i22.Stream<_i31.DocumentSnapshot<Object?>> get userDocument =>
      (super.noSuchMethod(
        Invocation.getter(#userDocument),
        returnValue: _i22.Stream<_i31.DocumentSnapshot<Object?>>.empty(),
        returnValueForMissingStub:
            _i22.Stream<_i31.DocumentSnapshot<Object?>>.empty(),
      ) as _i22.Stream<_i31.DocumentSnapshot<Object?>>);
  @override
  _i22.Stream<_i30.Provider?> get providerStream => (super.noSuchMethod(
        Invocation.getter(#providerStream),
        returnValue: _i22.Stream<_i30.Provider?>.empty(),
        returnValueForMissingStub: _i22.Stream<_i30.Provider?>.empty(),
      ) as _i22.Stream<_i30.Provider?>);
  @override
  _i22.Future<_i19.AppUser> get() => (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
        ),
        returnValue: _i22.Future<_i19.AppUser>.value(_FakeAppUser_17(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i22.Future<_i19.AppUser>.value(_FakeAppUser_17(
          this,
          Invocation.method(
            #get,
            [],
          ),
        )),
      ) as _i22.Future<_i19.AppUser>);
  @override
  _i22.Future<void> logOut() => (super.noSuchMethod(
        Invocation.method(
          #logOut,
          [],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  bool isAnonymous() => (super.noSuchMethod(
        Invocation.method(
          #isAnonymous,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  _i22.Stream<bool?> isAnonymousStream() => (super.noSuchMethod(
        Invocation.method(
          #isAnonymousStream,
          [],
        ),
        returnValue: _i22.Stream<bool?>.empty(),
        returnValueForMissingStub: _i22.Stream<bool?>.empty(),
      ) as _i22.Stream<bool?>);
  @override
  _i22.Future<void> linkWithCredential(_i32.AuthCredential? credential) =>
      (super.noSuchMethod(
        Invocation.method(
          #linkWithCredential,
          [credential],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> changeState(_i19.StateEnum? state) => (super.noSuchMethod(
        Invocation.method(
          #changeState,
          [state],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> addNotificationToken(String? token) => (super.noSuchMethod(
        Invocation.method(
          #addNotificationToken,
          [token],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  void removeNotificationToken(String? token) => super.noSuchMethod(
        Invocation.method(
          #removeNotificationToken,
          [token],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i22.Future<void> setHomeworkReminderTime(_i1.TimeOfDay? timeOfDay) =>
      (super.noSuchMethod(
        Invocation.method(
          #setHomeworkReminderTime,
          [timeOfDay],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> updateSettings(_i19.UserSettings? userSettings) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSettings,
          [userSettings],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> updateSettingsSingleFiled(
    String? fieldName,
    dynamic data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSettingsSingleFiled,
          [
            fieldName,
            data,
          ],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> updateUserTip(
    _i19.UserTipKey? userTipKey,
    bool? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserTip,
          [
            userTipKey,
            value,
          ],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  void setBlackboardNotifications(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setBlackboardNotifications,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void setCommentsNotifications(bool? enabled) => super.noSuchMethod(
        Invocation.method(
          #setCommentsNotifications,
          [enabled],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i22.Future<void> changeEmail(String? email) => (super.noSuchMethod(
        Invocation.method(
          #changeEmail,
          [email],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<void> addUser({
    required _i19.AppUser? user,
    bool? merge = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUser,
          [],
          {
            #user: user,
            #merge: merge,
          },
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
  @override
  _i22.Future<bool> deleteUser(_i4.SharezoneGateway? gateway) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [gateway],
        ),
        returnValue: _i22.Future<bool>.value(false),
        returnValueForMissingStub: _i22.Future<bool>.value(false),
      ) as _i22.Future<bool>);
  @override
  _i22.Future<_i20.AppFunctionsResult<bool>> updateUser(
          _i19.AppUser? userData) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [userData],
        ),
        returnValue: _i22.Future<_i20.AppFunctionsResult<bool>>.value(
            _FakeAppFunctionsResult_18<bool>(
          this,
          Invocation.method(
            #updateUser,
            [userData],
          ),
        )),
        returnValueForMissingStub:
            _i22.Future<_i20.AppFunctionsResult<bool>>.value(
                _FakeAppFunctionsResult_18<bool>(
          this,
          Invocation.method(
            #updateUser,
            [userData],
          ),
        )),
      ) as _i22.Future<_i20.AppFunctionsResult<bool>>);
  @override
  _i22.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i22.Future<void>.value(),
        returnValueForMissingStub: _i22.Future<void>.value(),
      ) as _i22.Future<void>);
}
