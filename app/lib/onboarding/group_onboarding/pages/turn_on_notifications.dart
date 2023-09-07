// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/notifications/notifications_permission.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/bottom_bar_button.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/title.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'is_it_first_person_using_sharezone.dart';

class TurnOnNotifications extends StatelessWidget {
  static const tag = 'onboarding-turn-on-notifications-page';

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingPageTemplate(
      top: _NotNowButton(),
      padding: const EdgeInsets.all(12),
      children: [
        _ClockAnimation(),
        const SizedBox(height: 12),
        _Title(),
        const SizedBox(height: 12),
        _Description(),
      ],
      bottomNavigationBar: _TurnOnButton(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingTitle("Erinnerungen und Benachrichtigungen erhalten");
  }
}

class _Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      getText(context),
      style: TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  String getText(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    if (bloc.isStudent)
      return 'Wir können dich an offene Hausaufgaben erinnern 😉 Zudem kannst du eine Benachrichtigung erhalten, wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt.';
    return 'Wenn jemand einen neuen Infozettel einträgt oder dir eine Nachricht schreibt, erhälst du eine Benachrichtigung. Somit bleibst du immer auf dem aktuellen Stand 💪';
  }
}

class _ClockAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      width: 175,
      child: FlareActor(
        "assets/flare/notification-animation.flr",
        animation: "Notification",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

class _NotNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final confirmed = (await confirmDialog(context))!;
        if (confirmed) {
          final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
          bloc.logTurnOfNotifiactions();
          await _continue(context);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
      ),
      child: const Text("Nicht jetzt"),
    );
  }

  Future<bool?> confirmDialog(BuildContext context) {
    return showLeftRightAdaptiveDialog<bool>(
      context: context,
      title: 'Keine Push-Nachrichten? 🤨',
      content: const Text(
          "Bist du dir sicher, dass du keine Benachrichtigungen erhalten möchtest?\n\nSollte jemand einen Infozettel eintragen, einen Kommentar zu einer Hausaufgabe hinzufügen oder dir eine Nachricht schreiben, würdest du keine Push-Nachrichten erhalten."),
      defaultValue: false,
      right: AdaptiveDialogAction(
        title: 'Ja',
        popResult: true,
      ),
    );
  }
}

class _TurnOnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 700,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BottomBarButton(
                text: 'Aktivieren',
                onTap: () async {
                  await requestNotificationsPermission(context);
                  await _continue(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestNotificationsPermission(BuildContext context) async {
    final notificationsPermission = context.read<NotificationsPermission>();
    await notificationsPermission.requestPermission();
  }
}

/// Diese Methode wird aufgerufen, wenn der Nutzer das Onboarding weiter
/// durchlaufen möchte (hat Push-Nachrichten aktiviert, bzw. deaktiviert).
Future<void> _continue(BuildContext context) async {
  final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
  final status = await bloc.status();
  if (status == GroupOnboardingStatus.full) {
    _navigateToNextPage(context);
  } else {
    _finishOnboarding(context);
  }
}

void _finishOnboarding(BuildContext context) {
  final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
  bloc.finsihOnboarding();
  Navigator.popUntil(context, ModalRoute.withName('/'));
}

void _navigateToNextPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    FadeRoute(
      child: GroupOnboardingIsItFirstPersonUsingSharezone(),
      tag: GroupOnboardingIsItFirstPersonUsingSharezone.tag,
    ),
  );
}
