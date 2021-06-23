import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/dashboard/dashboard_page.dart';
import 'package:sharezone/calendrical_events/page/calendrical_events_page.dart';
import 'package:sharezone/feedback/feedback_box_page.dart';
import 'package:sharezone/filesharing/file_sharing_page.dart';
import 'package:sharezone/groups/src/pages/course/group_page.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/pages/blackboard/details/blackboard_details.dart';
import 'package:sharezone/pages/blackboard_page.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:sharezone/pages/settings_page.dart';
import 'package:sharezone/timetable/timetable_page/timetable_event_details.dart';
import 'package:sharezone/timetable/timetable_page/timetable_page.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'dialogs/open_push_notification_support_dialog.dart';
import 'dialogs/open_push_notification_text_dialog.dart';
import 'models/push_notification.dart';
import 'models/push_notification_type.dart';

class PushNotificationActionHandler {
  final NavigationService navigationService;
  final NavigationBloc navigationBloc;

  const PushNotificationActionHandler(
      {@required this.navigationService, @required this.navigationBloc});

  Future<void> launchNotificationAction(
      BuildContext context, PushNotifaction pushNotifaction) async {
    if (pushNotifaction.hasID) {
      switch (pushNotifaction.id) {
        case PushNotificationType.homeworkReminder:
          _navigateToHomeworkPage(navigationBloc);
          break;
        case PushNotificationType.notificationDialog:
          openPushNotificationTextDialog(context, pushNotifaction);
          break;
        case PushNotificationType.support:
          openPushNotificationSupportDialog(context, pushNotifaction);
          break;
        case PushNotificationType.pushNamed:
          _navigateToNamed(pushNotifaction.idContent);
          break;
        case PushNotificationType.openLink:
          if (pushNotifaction.hasIdContent)
            launchURL(pushNotifaction.idContent);
          break;
        case PushNotificationType.blackboardItem:
          _navigateToBlackboardItem(pushNotifaction.idContent);
          break;
        case PushNotificationType.homeworkItem:
          _navigateToHomeworkItem(pushNotifaction.idContent);
          break;
        case PushNotificationType.timetableEventItem:
          _navigateToTimetableEventItem(pushNotifaction.idContent);
          break;
        default:
      }
    }
  }

  void _navigateToBlackboardItem(String id) {
    if (isNotEmptyOrNull(id))
      navigationService.pushWidget(BlackboardDetails.loadId(id),
          name: BlackboardDetails.tag);
  }

  void _navigateToHomeworkItem(String id) {
    if (isNotEmptyOrNull(id))
      navigationService.pushWidget(HomeworkDetails.loadId(id),
          name: HomeworkDetails.tag);
  }

  Future<void> _navigateToTimetableEventItem(String id) async {
    if (isNotEmptyOrNull(id)) {
      final context = navigationService.navigatorKey.currentContext;
      final api = BlocProvider.of<SharezoneContext>(context).api;
      final event = await api.timetable.getEvent(id);
      final design = api.course.getCourse(event.groupID)?.getDesign();
      return showTimetableEventDetails(context, event, design);
    }
  }

  void _navigateToNamed(String tag) {
    if (isNotEmptyOrNull(tag)) {
      switch (tag) {
        case DashboardPage.tag:
          navigationBloc.navigateTo(NavigationItem.overview);
          break;
        case GroupPage.tag:
          navigationBloc.navigateTo(NavigationItem.group);
          break;
        case HomeworkPage.tag:
          navigationBloc.navigateTo(NavigationItem.homework);
          break;
        case TimetablePage.tag:
          navigationBloc.navigateTo(NavigationItem.timetable);
          break;
        case BlackboardPage.tag:
          navigationBloc.navigateTo(NavigationItem.blackboard);
          break;
        case FileSharingPage.tag:
          navigationBloc.navigateTo(NavigationItem.filesharing);
          break;
        case CalendricalEventsPage.tag:
          navigationBloc.navigateTo(NavigationItem.events);
          break;
        case SettingsPage.tag:
          navigationBloc.navigateTo(NavigationItem.settings);
          break;
        case FeedbackPage.tag:
          navigationBloc.navigateTo(NavigationItem.feedbackBox);
          break;
        default:
          navigationService.pushNamed(tag);
      }
    }
  }

  Future<void> _navigateToHomeworkPage(NavigationBloc bloc) async {
    Future.delayed(
        const Duration(milliseconds: 100)); // Waiting for loading the page;
    bloc.navigateTo(NavigationItem.homework);
  }
}
