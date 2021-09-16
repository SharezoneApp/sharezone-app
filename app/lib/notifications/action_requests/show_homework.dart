import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details.dart';
import 'package:sharezone/util/navigation_service.dart';

ActionRegistration<ShowHomeworkRequest> showHomeworkRegistrationWith(
        ActionRequestExecutorFunc<ShowHomeworkRequest> executorFunc) =>
    ActionRegistration<ShowHomeworkRequest>(
      registerForActionTypeStrings: ShowHomeworkRequest.actionTypes,
      parseActionRequestFromNotification: _toShowHomeworkActionRequest,
      executeActionRequest: executorFunc,
    );

ShowHomeworkRequest _toShowHomeworkActionRequest(PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    ShowHomeworkRequest(HomeworkId(notification.actionData['id'] as String));

/// Show the detailed view of a single homework with the given [homeworkId].
///
/// See also [ShowHomeworkExecutor].
class ShowHomeworkRequest extends ActionRequest {
  static const Set<String> actionTypes = {'show-homework-with-id'};

  final HomeworkId homeworkId;

  @override
  List<Object> get props => [homeworkId];

  ShowHomeworkRequest(this.homeworkId);
}

class ShowHomeworkExecutor extends ActionRequestExecutor<ShowHomeworkRequest> {
  final NavigationService _navigationService;

  ShowHomeworkExecutor(this._navigationService);

  @override
  FutureOr<void> execute(ShowHomeworkRequest actionRequest) {
    return _navigationService.pushWidget(
        HomeworkDetails.loadId('${actionRequest.homeworkId}'),
        name: HomeworkDetails.tag);
  }
}
