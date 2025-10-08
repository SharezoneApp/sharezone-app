// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:interval_time_picker/models/visible_step.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/notifications/notifications_bloc.dart';
import 'package:sharezone/notifications/notifications_bloc_factory.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/widgets/matching_type_of_user_builder.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

const _leftPadding = EdgeInsets.only(left: 16);

class NotificationPage extends StatefulWidget {
  static const String tag = "notification-page";

  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NotificationsBlocFactory>(context).create();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>(
      bloc: _bloc,
      child: _NotificationPage(),
    );
  }
}

class _NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
      appBar: AppBar(
        title: const Text("Benachrichtigungen"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              children: <Widget>[
                MatchingTypeOfUserBuilder(
                  expectedTypeOfUser: TypeOfUser.student,
                  matchesTypeOfUserWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _HomeworkNotificationsCard(),
                      const Divider(),
                    ],
                  ),
                  notMatchingWidget: Container(),
                ),
                _BlackboardNotificationsCard(),
                const Divider(),
                _CommentsNotificationsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeworkNotificationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key("homework-notifications-card"),
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: _leftPadding,
            child: Headline("Offene Hausaufgaben"),
          ),
          _HomeworkNotificationsSwitch(),
          _HomeworkNotificationsTimeTile(),
        ],
      ),
    );
  }
}

class _HomeworkNotificationsSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotificationsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.notificationsForHomeworks,
      builder: (context, snapshot) {
        final bool notificationsForHomework = snapshot.data ?? true;
        return ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text("Erinnerungen für offene Hausaufgaben"),
          onTap:
              () => bloc.changeNotificationsForHomeworks(
                !notificationsForHomework,
              ),
          trailing: Switch.adaptive(
            value: notificationsForHomework,
            onChanged: bloc.changeNotificationsForHomeworks,
          ),
        );
      },
    );
  }
}

class _HomeworkNotificationsTimeTile extends StatelessWidget {
  Future<Time?> _openPicker(BuildContext context, {required Time initialTime}) {
    // Currently, the homework reminder only supports 30 minute intervals.
    const interval = 30;

    if (PlatformCheck.isDesktopOrWeb) {
      return showIntervalTimePicker(
        context: context,
        initialTime: initialTime.toTimeOfDay(),
        interval: interval,
        visibleStep: VisibleStep.thirtieths,
        errorInvalidText:
            'Nur volle und halbe Stunden sind erlaubt, z.B. 18:00 oder 18:30.',
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        initialEntryMode: TimePickerEntryMode.input,
      ).then((timeOfDay) {
        if (timeOfDay == null) return null;
        return Time.fromTimeOfDay(timeOfDay);
      });
    }

    return showDialog<TimeOfDay>(
      context: context,
      // We just use the iOS picker also on Android, because the Interval picker
      // looks a bit weird when setting the visual steps to 30 minutes.
      builder:
          (context) => CupertinoTimerPickerWithTimeOfDay(
            initialTime: initialTime.toTimeOfDay(),
            minutesInterval: interval,
          ),
    ).then((timeOfDay) {
      if (timeOfDay == null) return null;
      return Time.fromTimeOfDay(timeOfDay);
    });
  }

  Future<void> showPlusAdDialog(BuildContext context) async {
    await showSharezonePlusFeatureInfoDialog(
      context: context,
      navigateToPlusPage: () => navigateToSharezonePlusPage(context),
      title: const Text('Uhrzeit für Erinnerung am Vortag'),
      description: const Text(
        'Mit Sharezone Plus kannst du die Erinnerung für die Hausaufgaben individuell im 30-Minuten-Tack einstellen, z.B. 15:00 oder 15:30 Uhr.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotificationsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.notificationsForHomeworks,
      builder: (context, homeworkEnabled) {
        return StreamBuilder<TimeOfDay?>(
          stream: bloc.notificationsTimeForHomeworks,
          builder: (context, timeForHomeworks) {
            return ListTile(
              key: const Key("homework-notifications-time-tile"),
              leading: const Icon(Icons.access_time),
              title: const Text("Uhrzeit"),
              subtitle: Text(
                "${timeForHomeworks.data?.format(context) ?? "18:00"} Uhr",
              ),
              enabled: homeworkEnabled.data ?? true,
              onTap: () async {
                final isUnlocked = context
                    .read<SubscriptionService>()
                    .hasFeatureUnlocked(
                      SharezonePlusFeature.changeHomeworkReminderTime,
                    );

                if (isUnlocked) {
                  final newTime = await _openPicker(
                    context,
                    initialTime: Time(
                      hour: timeForHomeworks.data?.hour ?? 18,
                      minute: timeForHomeworks.data?.minute ?? 0,
                    ),
                  );

                  if (newTime != null) {
                    bloc.changeNotificationsTimeForHomeworks(
                      TimeOfDay(hour: newTime.hour, minute: newTime.minute),
                    );
                  }
                } else {
                  await showPlusAdDialog(context);
                }
              },
              trailing: const _HomeworkNotificationsTimeTileTrailing(),
            );
          },
        );
      },
    );
  }
}

class _HomeworkNotificationsTimeTileTrailing extends StatelessWidget {
  const _HomeworkNotificationsTimeTileTrailing();

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context.read<SubscriptionService>().hasFeatureUnlocked(
      SharezonePlusFeature.changeHomeworkReminderTime,
    );
    return isUnlocked ? const SizedBox() : const SharezonePlusChip();
  }
}

class _BlackboardNotificationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: _leftPadding, child: Headline("Infozettel")),
          _BlackboardNotificationsSwitch(),
        ],
      ),
    );
  }
}

class _BlackboardNotificationsSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotificationsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.notificationsForBlackboard,
      builder: (context, snapshot) {
        final notificationsForBlackboard = snapshot.data ?? true;
        return ListTileWithDescription(
          onTap:
              () => bloc.changeNotificationsForBlackboard(
                !notificationsForBlackboard,
              ),
          title: const Text("Benachrichtigungen für Infozettel"),
          trailing: Switch.adaptive(
            value: notificationsForBlackboard,
            onChanged: bloc.changeNotificationsForBlackboard,
          ),
          description: const Text(
            "Der Ersteller eines Infozettels kann regulieren, ob die Kursmitglieder darüber benachrichtigt werden sollen, dass ein "
            "neuer Infozettel erstellt wurde, bzw. es eine Änderung gab. Mit dieser Option kannst du diese Benachrichtigungen an- und ausschalten.",
            style: TextStyle(fontSize: 11.5),
          ),
        );
      },
    );
  }
}

class _CommentsNotificationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: _leftPadding, child: Headline("Kommentare")),
          _CommentsNotificationsSwitch(),
        ],
      ),
    );
  }
}

class _CommentsNotificationsSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotificationsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.notificationsForComments,
      builder: (context, snapshot) {
        final notificationsForComments = snapshot.data ?? true;
        return ListTileWithDescription(
          onTap:
              () => bloc.changeNotificationsForComments(
                !notificationsForComments,
              ),
          title: const Text("Benachrichtigungen für Kommentare"),
          trailing: Switch.adaptive(
            value: notificationsForComments,
            onChanged: bloc.changeNotificationsForComments,
          ),
          description: const Text(
            "Erhalte eine Push-Nachricht, sobald ein neuer Nutzer einen neuen Kommentar unter einer Hausaufgabe oder einem Infozettel verfasst hat.",
            style: TextStyle(fontSize: 11.5),
          ),
        );
      },
    );
  }
}
