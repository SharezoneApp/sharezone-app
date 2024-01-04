// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:add_2_calendar/add_2_calendar.dart' as add_2_calendar;
import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/timetable_edit/event/timetable_event_edit_page.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum _EventModelSheetAction { edit, delete, report }

Future<bool?> showDeleteEventConfirmationDialog(BuildContext context) async {
  return await showLeftRightAdaptiveDialog<bool>(
    defaultValue: false,
    context: context,
    right: AdaptiveDialogAction.delete,
    content: !ThemePlatform.isCupertino
        ? const Text("Möchtest du wirklich diesen Termin löschen?")
        : null,
    title: ThemePlatform.isCupertino
        ? "Möchtest du wirklich diesen Termin löschen?"
        : null,
  );
}

Future<void> showTimetableEventDetails(
  BuildContext context,
  CalendricalEvent event,
  Design? design,
) async {
  final navigationService = BlocProvider.of<NavigationService>(context);

  final popOption = await navigationService.pushWidget<_EventModelSheetAction>(
    _TimetableEventDetailsPage(
      event: event,
      design: design ?? Design.standard(),
    ),
    name: _TimetableEventDetailsPage.tag,
  );
  if (!context.mounted) return;

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
    case null:
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
    if (!context.mounted) return;

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
  if (!context.mounted) return;

  final confirmed = await showDeleteEventConfirmationDialog(context);
  if (confirmed == true && context.mounted) {
    _deleteEventAndShowConfirmationSnackbar(context, event);
  }
}

Future<void> _deleteEventAndShowConfirmationSnackbar(
    BuildContext context, CalendricalEvent event) async {
  final timetableGateway =
      BlocProvider.of<SharezoneContext>(context).api.timetable;
  timetableGateway.deleteEvent(event);

  await waitingForPopAnimation();
  if (!context.mounted) return;

  showSnackSec(
    text: 'Termin wurde gelöscht',
    context: context,
    seconds: 2,
  );
}

class _TimetableEventDetailsPage extends StatelessWidget {
  static const tag = "timetable-event-details-page";

  final CalendricalEvent event;
  final Design? design;

  const _TimetableEventDetailsPage({
    required this.event,
    this.design,
  });

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
        api.course.getRoleFromCourseNoSync(event.groupID)!, isAuthor);
    final isExam = event.eventType == Exam();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
                const SizedBox(height: 12),
                _TitleAndDate(
                  design: design,
                  event: event,
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: Text.rich(
                    TextSpan(
                      style: TextStyle(
                          color: Theme.of(context).isDarkTheme
                              ? Colors.white
                              : Colors.grey[800],
                          fontSize: 16),
                      children: <TextSpan>[
                        const TextSpan(text: "Kursname: "),
                        TextSpan(
                            text: courseName,
                            style: TextStyle(color: design?.color))
                      ],
                    ),
                  ),
                ),
                if (event.eventType is OtherEventType == false)
                  ListTile(
                    leading: const Icon(Icons.label),
                    title: Text("Art: ${event.eventType.name}"),
                  ),
                ListTile(
                  leading: const Icon(Icons.place),
                  title: Text("Raum: ${event.place ?? "-"}"),
                ),
                if (event.detail != null && event.detail != "")
                  ListTile(
                    leading: const Icon(Icons.notes),
                    title: MarkdownBody(
                      data:
                          "${isExam ? "Themen der Prüfung" : "Details"}:\n${event.detail}",
                      selectable: true,
                      onTapLink: (url, _, __) =>
                          launchURL(url, context: context),
                      softLineBreak: true,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        theme.copyWith(
                          textTheme: theme.textTheme.copyWith(
                            bodyMedium: TextStyle(
                              color: Theme.of(context).isDarkTheme
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

class _TitleAndDate extends StatelessWidget {
  const _TitleAndDate({
    required this.design,
    required this.event,
  });

  final Design? design;
  final CalendricalEvent event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _Square(color: design?.color),
      title: Text(
        event.title,
        style: const TextStyle(
          fontSize: 26,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          "${event.date.parser.toYMMMMEEEEd} • ${event.startTime} - ${event.endTime}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square({
    required this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _DeleteIcon extends StatelessWidget {
  const _DeleteIcon();

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
  const _EditIcon();

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
  const _AddToMyCalendarButton({required this.event});

  final CalendricalEvent event;

  Future<void> addEventToLocalCalendar(BuildContext context) async {
    final timezone = await _getTimezoneForMobile();
    final calendarEvent = add_2_calendar.Event(
      startDate: event.startDateTime,
      endDate: event.endDateTime,
      title: event.title,
      description: event.detail,
      location: event.place,
      timeZone: timezone,
    );
    if (!context.mounted) return;

    add_2_calendar.Add2Calendar.addEvent2Cal(calendarEvent);

    _logAddEventToMyCalendarEvent(context);
  }

  void showPlusAdDialog(BuildContext context) {
    showSharezonePlusFeatureInfoDialog(
      context: context,
      navigateToPlusPage: () => navigateToSharezonePlusPage(context),
      description: const Text(
          'Mit Sharezone Plus kannst du kinderleicht die Termine aus Sharezone in deinen lokalen Kalender (z.B. Apple oder Google Kalender) übertragen.'),
      title: const Text('Termin zum Kalender hinzufügen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Eigentlich sollte das Plugin auf Web funktioniert. Leider ist dies nicht
    // der Fall, weswegen der Button für Web ausgeblendet wird.
    // Ticket: https://github.com/ja2375/add_2_calendar/issues/32
    if (PlatformCheck.isDesktopOrWeb) return const Text("");

    final isUnlocked = context
        .read<SubscriptionService>()
        .hasFeatureUnlocked(SharezonePlusFeature.addEventToLocalCalendar);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(),
          MaxWidthConstraintBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        "In Kalender eintragen".toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (!isUnlocked) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 12, right: 4),
                        child: SharezonePlusChip(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ]
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.only(
                    left: 12,
                    top: 6,
                    right: isUnlocked ? 12 : 4,
                    bottom: 6,
                  ),
                ),
                onPressed: () async {
                  if (isUnlocked) {
                    await addEventToLocalCalendar(context);
                  } else {
                    showPlusAdDialog(context);
                  }
                },
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
