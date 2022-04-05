// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/settings/notifications_bloc.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/widgets/machting_type_of_user_stream_builder.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

const _leftPadding = EdgeInsets.only(left: 16);

class NotificationPage extends StatelessWidget {
  static const String tag = "notification-page";

  @override
  Widget build(BuildContext context) {
    final userApi = BlocProvider.of<SharezoneContext>(context).api.user;
    return BlocProvider<NotificationsBloc>(
      bloc: NotificationsBloc(userApi),
      child: _NotificationPage(),
    );
  }
}

class _NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
      appBar:
          AppBar(title: const Text("Benachrichtigungen"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              children: <Widget>[
                MatchingTypeOfUserStreamBuilder(
                  expectedTypeOfUser: TypeOfUser.student,
                  matchesTypeOfUserWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _HomeworkNotificationsCard(),
                      const Divider(),
                    ],
                  ),
                  notMatchtingWidget: Container(),
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
            leading: Icon(Icons.notifications),
            title: Text("Erinnerungen für offene Hausaufgaben"),
            onTap: () =>
                bloc.changeNotificationsForHomeworks(!notificationsForHomework),
            trailing: Switch.adaptive(
              value: notificationsForHomework,
              onChanged: bloc.changeNotificationsForHomeworks,
            ),
          );
        });
  }
}

class _HomeworkNotificationsTimeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NotificationsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.notificationsForHomeworks,
      builder: (context, homeworkEnabled) {
        return StreamBuilder<TimeOfDay>(
          stream: bloc.notificationsTimeForHomeworks,
          builder: (context, timeForHomeworks) {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Uhrzeit"),
              subtitle: Text(
                  "${timeForHomeworks.data?.format(context) ?? "18:00"} Uhr"),
              enabled: homeworkEnabled.data ?? true,
              onTap: () async {
                final newTime = await selectTime(context,
                    initialTime: Time(
                        hour: timeForHomeworks?.data?.hour ?? 18,
                        minute: timeForHomeworks?.data?.minute ?? 0),
                    minutesInterval: 30);

                if (newTime != null) {
                  bloc.changeNotificationsTimeForHomeworks(
                      TimeOfDay(hour: newTime.hour, minute: newTime.minute));
                }
              },
            );
          },
        );
      },
    );
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
          const Padding(
            padding: _leftPadding,
            child: Headline("Infozettel"),
          ),
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
          onTap: () => bloc
              .changeNotificationsForBlackboard(!notificationsForBlackboard),
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
          const Padding(
            padding: _leftPadding,
            child: Headline("Kommentare"),
          ),
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
          onTap: () =>
              bloc.changeNotificationsForComments(!notificationsForComments),
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
