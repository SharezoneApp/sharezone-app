import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:design/design.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/timetable/timetable_edit/event/timetable_event_edit_page.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_utils/dimensions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add_2_calendar;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

enum _EventModelSheetAction { edit, delete, report }

Future<bool> showDeleteEventConfirmationDialog(BuildContext context) async {
  return await showLeftRightAdaptiveDialog<bool>(
    defaultValue: false,
    context: context,
    right: AdaptiveDialogAction.delete,
    content: !ThemePlatform.isCupertino
        ? Text("Möchtest du wirklich diesen Termin löschen?")
        : null,
    title: ThemePlatform.isCupertino
        ? "Möchtest du wirklich diesen Termin löschen?"
        : null,
  );
}

Future<void> showTimetableEventDetails(
    BuildContext context, CalendricalEvent event, Design design) async {
  final navigatonService = BlocProvider.of<NavigationService>(context);

  final popOption = await navigatonService.pushWidget<_EventModelSheetAction>(
    _TimetableEventDetailsPage(
        event: event, design: design ?? Design.standard()),
    name: _TimetableEventDetailsPage.tag,
  );
  switch (popOption) {
    case _EventModelSheetAction.delete:
      deleteEvent(context, event);
      break;
    case _EventModelSheetAction.edit:
      openTimetableEventEditPage(context, event);
      break;
    case _EventModelSheetAction.report:
      openReportPage(context, ReportItemReference.event(event.eventID));
      break;
  }
}

Future<void> openTimetableEventEditPage(
    BuildContext context, CalendricalEvent event) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final confirmed = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => TimetableEditEventPage(
        event,
        api.timetable,
        api.connectionsGateway,
      ),
      settings: const RouteSettings(name: TimetableEditEventPage.tag),
    ),
  );
  if (confirmed != null && confirmed) {
    await waitingForPopAnimation();
    showSnackSec(
      text: 'Termin wurde erfolgreich bearbeitet',
      context: context,
      seconds: 2,
      behavior: SnackBarBehavior.fixed,
    );
  }
}

Future<void> deleteEvent(BuildContext context, CalendricalEvent event) async {
  await waitingForBottomModelSheetClosing();
  final confirmed = await showDeleteEventConfirmationDialog(context);
  if (confirmed) _deleteEventAndShowConfirmationSnackbar(context, event);
}

Future<void> _deleteEventAndShowConfirmationSnackbar(
    BuildContext context, CalendricalEvent event) async {
  final timetableGateway =
      BlocProvider.of<SharezoneContext>(context).api.timetable;
  timetableGateway.deleteEvent(event);

  await waitingForPopAnimation();
  showSnackSec(
    text: 'Termin wurde gelöscht',
    context: context,
    seconds: 2,
  );
}

class _TimetableEventDetailsPage extends StatelessWidget {
  static const tag = "timetable-event-details-page";

  final CalendricalEvent event;
  final Design design;

  const _TimetableEventDetailsPage({Key key, @required this.event, this.design})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseName = BlocProvider.of<SharezoneContext>(context)
            .api
            .course
            .getCourse(event.groupID)
            ?.name ??
        "-";
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final isAuthor = api.uID == event.authorID;
    final hasPermissionsToManageLessons = hasPermissionToManageEvents(
        api.course.getRoleFromCourseNoSync(event.groupID), isAuthor);
    final isExam = event.eventType == Exam();
    final theme = Theme.of(context);

    final dimensions = Dimensions.fromMediaQuery(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        centerTitle: dimensions.isDesktopModus,
        actions: [
          ReportIcon(
            item: ReportItemReference.event(event.eventID),
            tooltip: '${isExam ? 'Prüfung' : 'Termin'} melden',
          ),
          if (hasPermissionsToManageLessons) ...const [
            _EditIcon(),
            _DeleteIcon(),
          ]
        ],
      ),
      bottomNavigationBar: _AddToMyCalendarButton(event: event),
      body: SingleChildScrollView(
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.group),
                  title: Text.rich(
                    TextSpan(
                      style: TextStyle(
                          color: isDarkThemeEnabled(context)
                              ? Colors.white
                              : Colors.grey[800],
                          fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(text: "Kursname: "),
                        TextSpan(
                            text: courseName,
                            style: TextStyle(color: design.color))
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: Text("Datum: ${event.date.parser.toYMMMMEEEEd}"),
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text("${event.startTime} - ${event.endTime}"),
                ),
                if (event.eventType is OtherEventType == false)
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text("Art: ${event.eventType.name ?? "-"}"),
                  ),
                ListTile(
                  leading: const Icon(Icons.place),
                  title: Text("Raum: ${event.place ?? "-"}"),
                ),
                if (event.detail != null && event.detail != "")
                  ListTile(
                    leading: const Icon(Icons.details),
                    title: MarkdownBody(
                      data:
                          "${isExam ? "Themen der Prüfung" : "Details"}:\n${event.detail}",
                      selectable: true,
                      onTapLink: (url, _, __) =>
                          launchURL(url, context: context),
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        theme.copyWith(
                          textTheme: theme.textTheme.copyWith(
                            bodyText2: TextStyle(
                              color: isDarkThemeEnabled(context)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ).copyWith(a: linkStyle(context)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, _EventModelSheetAction.delete),
      icon: const Icon(Icons.delete),
      tooltip: 'Löschen',
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context, _EventModelSheetAction.edit),
      icon: const Icon(Icons.edit),
      tooltip: 'Bearbeiten',
    );
  }
}

/// Öffnet den Standardkalender auf dem Gerät, um einen neuen Termin hinzuzufügen.
/// Bei dem Kalendar auf dem Gerät wird direkt der Hinzufügen-Dialog mit den jeweiligen
/// Daten aus dem [event] vorausgefüllt geöffnet.
class _AddToMyCalendarButton extends StatelessWidget {
  const _AddToMyCalendarButton({Key key, @required this.event})
      : super(key: key);

  final CalendricalEvent event;

  @override
  Widget build(BuildContext context) {
    // Eigentlich sollte das Plugin auf Web funktioniert. Leider ist dies nicht
    // der Fall, weswegen der Button für Web ausgeblendet wird.
    // Ticket: https://github.com/ja2375/add_2_calendar/issues/32
    if (PlatformCheck.isDesktopOrWeb) return Text("");

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          MaxWidthConstraintBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle),
                  label: Text("Zu meinem Kalender hinzufügen".toUpperCase()),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    final timezone = await _getTimezoneForMobile();
                    final calendarEvent = add_2_calendar.Event(
                      startDate: event.startDateTime,
                      endDate: event.endDateTime,
                      title: event.title,
                      // Wenn description oder location null ist, crasht die App
                      // bei iOS-Geräten. Dieser Fehler liegt an dem Package
                      // add_2_calendar. Ticket:
                      // https://github.com/ja2375/add_2_calendar/issues/37
                      //
                      // Für Android ist dieser Workaround mit dem leeren String
                      // nicht notwenidg, da es dort die beiden Werte auch null
                      // sein können.
                      //
                      // Der Workaround mit dem leeren String den Nachteil mit
                      // sich, dass auch bei dem Termin in der jeweiligen
                      // Kalender-App ein leerer String eingetragen wird.
                      // Deswegen sollte der Workaround nur auf den Plattformen
                      // angewendet, wo dieser auch benötigt wird (in diesem
                      // Fall iOS).
                      description:
                          event.detail ?? (PlatformCheck.isIOS ? '' : null),
                      location:
                          event.place ?? (PlatformCheck.isIOS ? '' : null),
                      timeZone: timezone,
                    );

                    add_2_calendar.Add2Calendar.addEvent2Cal(calendarEvent);

                    _logAddEventToMyCalendarEvent(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Das Package "FlutterNativeTimezone" ist nur für Android & iOS verfügbar. Da
  // dieses Widget niemals für Web & macOS gebuildet wird, wird hier kein Fehler
  // geworfen.
  Future<String> _getTimezoneForMobile() async {
    return FlutterNativeTimezone.getLocalTimezone();
  }

  void _logAddEventToMyCalendarEvent(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    analytics.log(NamedAnalyticsEvent(name: 'add_event_to_my_calendar'));
  }
}
