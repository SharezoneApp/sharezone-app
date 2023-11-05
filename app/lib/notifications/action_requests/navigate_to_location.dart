// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:notifications/notifications.dart';
import 'package:sharezone/blackboard/blackboard_page.dart';
import 'package:sharezone/calendrical_events/page/calendrical_events_page.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/filesharing/file_sharing_page.dart';
import 'package:sharezone/groups/src/pages/course/group_page.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/homework/parent/homework_page.dart';
import 'package:sharezone/settings/settings_page.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/util/navigation_service.dart';

ActionRegistration<
    NavigateToLocationRequest> navigateToLocationRegistrationWith(
        ActionRequestExecutorFunc<NavigateToLocationRequest> executorFunc) =>
    ActionRegistration<NavigateToLocationRequest>(
      registerForActionTypeStrings: NavigateToLocationRequest.actionTypes,
      parseActionRequestFromNotification: _toNavigateToLocationActionRequest,
      executeActionRequest: executorFunc,
    );

NavigateToLocationRequest _toNavigateToLocationActionRequest(
        PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    NavigateToLocationRequest(notification.actionData['page-tag'] as String);

/// Navigates to a page inside the app that has the corresponsing
/// [navigationTag] (e.g. navigate to the [FileSharingPage]).
///
/// If in the future there is a more structure navigation which includes
/// subpages (e.g. navigation via Navigator 2.0 and paths) then attributes for
/// a location might be added (e.g. a `path` attribute).
///
/// See also [NavigateToLocationExecutor].
class NavigateToLocationRequest extends ActionRequest {
  static const Set<String> actionTypes = {'navigate-to-given-location'};

  /// The Page.tag (e.g. [DashboardPage.tag]) static attribute that corresponds
  /// to a specific page.
  /// Might be replaced with a path in the future.
  /// See: https://github.com/SharezoneApp/sharezone-app/pull/3#discussion_r691241471
  final String navigationTag;

  @override
  List<Object> get props => [navigationTag];

  NavigateToLocationRequest(this.navigationTag) {
    _throwIfNullOrEmptyString(navigationTag, 'navigationTag');
  }
}

void _throwIfNullOrEmptyString(String value, String name) {
  ArgumentError.checkNotNull(value, name);
  if (value.isEmpty) {
    throw ArgumentError('$name must not be an empty String.');
  }
}

class NavigateToLocationExecutor
    extends ActionRequestExecutor<NavigateToLocationRequest> {
  final NavigationBloc? _navigationBloc;
  final NavigationService? _navigationService;

  NavigateToLocationExecutor(this._navigationBloc, this._navigationService);

  @override
  FutureOr<void> execute(NavigateToLocationRequest actionRequest) {
    final tag = actionRequest.navigationTag;
    switch (tag) {
      case DashboardPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.overview);
        break;
      case GroupPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.group);
        break;
      case HomeworkPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.homework);
        break;
      case TimetablePage.tag:
        _navigationBloc!.navigateTo(NavigationItem.timetable);
        break;
      case BlackboardPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.blackboard);
        break;
      case FileSharingPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.filesharing);
        break;
      case CalendricalEventsPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.events);
        break;
      case SettingsPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.settings);
        break;
      case FeedbackPage.tag:
        _navigationBloc!.navigateTo(NavigationItem.feedbackBox);
        break;
      default:
        _navigationService!.pushNamed(tag);
    }
  }
}
