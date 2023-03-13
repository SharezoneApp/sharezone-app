// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/onboarding/group_onboarding/analytics/group_onboarding_analytics.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:user/user.dart';

/// Über den [GroupOnboardingBloc] werden die entsprechenden Befehle
/// an das [CourseGateway] und [SchoolClassGateway] weitergegeben.
class GroupOnboardingBloc extends BlocBase {
  final CourseGateway _courseGateway;
  final SchoolClassGateway _schoolClassGateway;
  final SignUpBloc _signedUpBloc;
  final GroupOnboardingAnalytics _analytics;
  final Stream<Beitrittsversuch> beitrittsversucheStream;
  final Stream<bool> signedUp;
  final TypeOfUser typeOfUser;

  TeacherType teacherType;

  GroupOnboardingBloc(
    this._courseGateway,
    this._schoolClassGateway,
    this._signedUpBloc,
    this._analytics,
    this.beitrittsversucheStream,
  )   : typeOfUser = _signedUpBloc?.typeOfUser,
        signedUp = _signedUpBloc?.signedUp;

  Function(TeacherType) get setTeacherType => (tt) => teacherType = tt;

  /// Nutzer überspringt das Group-Onboarding
  void skipOnboarding() {
    _closeOnboarding();
    _analytics.logSkippedGroupOnboarding();
  }

  Future<bool> get isGroupOnboardingActive => signedUp.first;

  /// Nutzer überspringt das Group-Onboarding
  Future<void> finsihOnboarding() async {
    _closeOnboarding();
    _analytics.logFinishedGroupOnboarding();
  }

  bool get isStudent => typeOfUser == TypeOfUser.student;
  bool get isTeacher => typeOfUser == TypeOfUser.teacher;

  Stream<GroupInfo> schoolClassGroupInfo(String schoolClassId) =>
      _schoolClassGateway
          .streamSingleSchoolClass(schoolClassId)
          .map((schoolClass) => schoolClass.toGroupInfo());

  Stream<List<GroupInfo>> courseGroupInfos() => _courseGateway
      .streamCourses()
      .map((courses) => courses.map((c) => c.toGroupInfo()).toList());

  void _closeOnboarding() => _signedUpBloc.setSignedUp(false);

  void logTurnOfNotifiactions() => _analytics.logTurnOffNotifications();

  void logShareLink() => _analytics.logShareSharecode();

  void logShareQrcode() => _analytics.logShareQrCode();

  void logShareSharecode() => _analytics.logShareQrCode();

  /// Dieser Stream gibt den Status über das Anzeigen des GroupOnboardings an.
  ///
  /// Falls der Nutzer einen JoinLink (Beitrittsversuch) verwendet, soll kein
  /// GroupOnboarding angezeigt werden, weil dies nicht mehr nötigt ist (Nutzer
  /// ist ja bereits einer Gruppe beigreten).
  /// Verwendet der Nutzer jedoch ein iOS-Gerät, sollte trotzdem noch die Seite
  /// [TurnOnNotifcations] angezeigt werden, damit der Nutzer aufgefordert wird,
  /// die Push-Nachrichten zu aktivieren.
  ///
  /// Verwendet der Nutzer keine JoinLinks und hat sich gerade registriert
  /// ([signedUp] == true), so soll das GroupOnboarding angezeigt werden.
  ///
  /// Hat der Nutzer sich gerade nicht registriert ([signedUp == false]), so soll kein
  /// GroupOnboarding angezeigt werden.
  Future<GroupOnboardingStatus> status() async {
    bool usedJoinLink;
    if (PlatformCheck.isDesktopOrWeb) {
      usedJoinLink = false;
    } else {
      final beitrittsversuch = await beitrittsversucheStream.first;
      usedJoinLink = beitrittsversuch?.sharecode != null;
    }

    final hasSignedUp = await signedUp.first;

    if (usedJoinLink && hasSignedUp) {
      if (PlatformCheck.isIOS) {
        return GroupOnboardingStatus.onlyNameAndTurnOfNotifactions;
      } else {
        return GroupOnboardingStatus.onlyName;
      }
    }

    if (!usedJoinLink && hasSignedUp) return GroupOnboardingStatus.full;

    return GroupOnboardingStatus.none;
  }

  @override
  void dispose() {}
}

enum TeacherType { classTeacher, courseTeacher }

enum GroupOnboardingStatus {
  /// Kein Group-Onboarding anzeigen
  none,

  /// Nur die Seite anzeigen, wo der Nutzer gefragt wird,
  /// welchen Namen er wählen möchten.
  onlyName,

  /// Nur die Seiten anzeigen, wo der Nutzer gefragt wird,
  /// welchen Namen er wählen möchte und wo er nach der
  /// Aktivieriung der Push-Nachrichten gefragt wird.
  onlyNameAndTurnOfNotifactions,

  /// Gesamtes Group-Onboarding anzeigen
  full,
}
