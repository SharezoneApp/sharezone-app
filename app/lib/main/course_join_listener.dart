// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart' hide Sharecode;
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/dynamic_links/beitrittsversuch.dart';
import 'package:sharezone/dynamic_links/gruppen_beitritts_transformer.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_function.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CourseJoinListener extends StatelessWidget {
  final Stream<Beitrittsversuch?> beitrittsversuche;
  final Widget? child;
  final GroupJoinFunction groupJoinFunction;

  const CourseJoinListener({
    super.key,
    required this.beitrittsversuche,
    required this.groupJoinFunction,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Beitrittsversuch?>(
      stream: beitrittsversuche,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is KursBereitsBeigetretenException) {
            Future.delayed(const Duration(microseconds: 200)).then((_) {
              showSimpleNotification(
                const Text('Du bist der Gruppe bereits beigetreten!'),
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
                trailing: const Icon(Icons.error_outline, color: Colors.red),
                leading: const Icon(Icons.link),
              );
            });
          }
        }
        if (snapshot.hasData) {
          final sharecode = snapshot.data!.sharecode;
          _joinGroup(sharecode);
        }
        return child!;
      },
    );
  }

  Future<void> _joinGroup(Sharecode sharecode) async {
    Future.delayed(const Duration(microseconds: 200)).then((_) {
      showSimpleNotification(
        Text("$sharecode beitreten..."),
        autoDismiss: true,
        slideDismissDirection: DismissDirection.horizontal,
        trailing: const SizedBox(
          height: 25,
          width: 25,
          child: AccentColorCircularProgressIndicator(),
        ),
        leading: const Icon(Icons.link),
      );
      groupJoinFunction
          .runGroupJoinFunction(enteredValue: '$sharecode', version: 1)
          .then((groupJoinResult) {
            if (groupJoinResult is SuccessfulJoinResult) {
              final groupInfo = groupJoinResult.groupInfo;
              final groupname = groupInfo.name;
              showSimpleNotification(
                Text(
                  groupInfo.groupType == GroupType.course
                      ? 'Du bist dem Kurs "${groupname ?? "???"}" beigetreten'
                      : 'Du bist der Klasse "${groupname ?? "???"}" beigetreten',
                ),
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
                trailing: const Icon(Icons.check, color: Colors.lightGreen),
                leading: const Icon(Icons.link),
              );
            } else if (groupJoinResult is ErrorJoinResult) {
              showSimpleNotification(
                const Text(
                  'Ein Fehler ist beim Beitreten aufgetreten! Versuche es erneut oder schreibe den Support an.',
                ),
                autoDismiss: true,
                slideDismissDirection: DismissDirection.horizontal,
                trailing: const Icon(Icons.error, color: Colors.red),
                leading: const Icon(Icons.link),
                duration: const Duration(seconds: 3),
              );
            }
          });
    });
  }
}
