// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart' hide Sharecode;
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_function.dart';
import 'package:sharezone/groups/group_join/models/group_join_exception.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CourseJoinListener extends StatefulWidget {
  final Stream<Beitrittsversuch?> beitrittsversuche;
  final Widget child;
  final GroupJoinFunction groupJoinFunction;

  const CourseJoinListener({
    super.key,
    required this.beitrittsversuche,
    required this.groupJoinFunction,
    required this.child,
  });

  @override
  State<CourseJoinListener> createState() => _CourseJoinListenerState();
}

class _CourseJoinListenerState extends State<CourseJoinListener> {
  StreamSubscription<Beitrittsversuch?>? _beitrittsversucheSubscription;

  void showLinkNotification(String message, {Widget? trailing}) {
    showSimpleNotification(
      Text(message),
      autoDismiss: true,
      slideDismissDirection: DismissDirection.horizontal,
      trailing: trailing,
      leading: const Icon(Icons.link),
      duration: const Duration(seconds: 5),
    );
  }

  void showErrorNotification(String message) {
    showLinkNotification(
      message,
      trailing: const Icon(Icons.error_outline, color: Colors.red),
    );
  }

  void showLoadingNotification(String message) {
    showLinkNotification(
      message,
      trailing: const SizedBox(
        height: 25,
        width: 25,
        child: AccentColorCircularProgressIndicator(),
      ),
    );
  }

  void showSuccessNotification(String message) {
    showLinkNotification(
      message,
      trailing: const Icon(Icons.check, color: Colors.lightGreen),
    );
  }

  Future<void> joinGroup(Sharecode sharecode) async {
    final l10n = context.l10n;
    Future.delayed(const Duration(microseconds: 200)).then((_) async {
      showLoadingNotification(l10n.courseJoinNotificationLoading(sharecode));
      final result = await widget.groupJoinFunction.runGroupJoinFunction(
        enteredValue: '$sharecode',
        version: 1,
      );
      if (result is SuccessfulJoinResult) {
        final groupInfo = result.groupInfo;
        final groupName = groupInfo.name;
        final message = switch (groupInfo.groupType) {
          GroupType.course => l10n.courseJoinNotificationJoinedCourse(
            groupName ?? "???",
          ),
          GroupType.schoolclass => l10n.courseJoinNotificationJoinedClass(
            groupName ?? "???",
          ),
        };
        showSuccessNotification(message);
      } else if (result is ErrorJoinResult) {
        showErrorNotification(switch (result.groupJoinException) {
          NoInternetGroupJoinException() =>
            l10n.courseJoinNotificationNoInternet,
          GroupNotPublicGroupJoinException() =>
            l10n.courseJoinNotificationJoinForbidden,
          AlreadyMemberGroupJoinException() =>
            l10n.courseJoinNotificationAlreadyMember,
          SharecodeNotFoundGroupJoinException() =>
            l10n.courseJoinNotificationGroupNotFound,
          UnknownGroupJoinException() =>
            l10n.courseJoinNotificationUnknownError,
        });
      }
    });
  }

  void onBeitrittsStreamError(dynamic error) {
    final l10n = context.l10n;
    Future.delayed(const Duration(microseconds: 200)).then((_) {
      if (error is KursBereitsBeigetretenException) {
        showErrorNotification(l10n.courseJoinNotificationAlreadyMember);
      } else {
        showErrorNotification(
          l10n.courseJoinNotificationUnknownErrorWithReason('$error'),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _beitrittsversucheSubscription = widget.beitrittsversuche.listen((
      beitrittsversuch,
    ) {
      if (beitrittsversuch == null) return;
      final sharecode = beitrittsversuch.sharecode;
      joinGroup(sharecode);
    }, onError: onBeitrittsStreamError);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _beitrittsversucheSubscription?.cancel();
    super.dispose();
  }
}
