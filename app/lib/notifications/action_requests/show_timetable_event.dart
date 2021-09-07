import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';

ActionRegistration<
    ShowTimetableEventRequest> showTimetableEventRegistrationWith(
        ActionRequestExecutorFunc<ShowTimetableEventRequest> executorFunc) =>
    ActionRegistration<ShowTimetableEventRequest>(
      registerForActionTypeStrings: ShowTimetableEventRequest.actionTypes,
      parseActionRequestFromNotification: _toShowTimetableEventActionRequest,
      executeActionRequest: executorFunc,
    );

ShowTimetableEventRequest _toShowTimetableEventActionRequest(
        PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    ShowTimetableEventRequest(TimetableEventId(notification.actionData['id']));

/// Show the detailed view of a single timetable event with the given
/// [timetableEventId].
///
/// See also [ShowTimetableEventExecutor].
class ShowTimetableEventRequest extends ActionRequest {
  static const Set<String> actionTypes = {'show-timetable-event-with-id'};

  final TimetableEventId timetableEventId;

  @override
  List<Object> get props => [timetableEventId];

  ShowTimetableEventRequest(this.timetableEventId);
}

class ShowTimetableEventExecutor
    extends ActionRequestExecutor<ShowTimetableEventRequest> {
  final BuildContext Function() _getCurrentContext;
  final TimetableGateway _timetableGateway;
  final CourseGateway _courseGateway;

  ShowTimetableEventExecutor(
      this._getCurrentContext, this._timetableGateway, this._courseGateway);

  @override
  FutureOr<void> execute(ShowTimetableEventRequest actionRequest) async {
    final event =
        await _timetableGateway.getEvent('${actionRequest.timetableEventId}');
    final design = _courseGateway.getCourse(event.groupID)?.getDesign();
    return showTimetableEventDetails(_getCurrentContext(), event, design);
  }
}
