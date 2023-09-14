// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/pages/group_join_course_selection_page.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'bloc/group_join_bloc.dart';
import 'group_join_page.dart';
import 'models/group_join_result.dart';
import 'widgets/error_join_result_dialog.dart';
import 'widgets/loading_join_result_dialog.dart';
import 'widgets/require_course_selection_result_dialog.dart';
import 'widgets/successful_join_result_dialog.dart';

class GroupJoinResultDialog {
  final GroupJoinBloc groupJoinBloc;

  GroupJoinResultDialog(this.groupJoinBloc);

  StateSheetContent mapStateSheetContentFromJoinResult(
    GroupJoinResult groupJoinResult,
    BuildContext context,
  ) {
    if (groupJoinResult is SuccessfullJoinResult) {
      return StateSheetContent(
        body: SuccessfulJoinResultDialog(result: groupJoinResult),
        actions: [
          ActionItem(
            title: "Mehr beitreten",
            onSelect: () {
              groupJoinBloc.clear();
              Navigator.pop(context);
              Navigator.pop(context);
              openGroupJoinPage(context);
            },
          ),
          ActionItem(
            title: "Fertig",
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onSelect: () async {
              Navigator.pop(context);
              Navigator.pop(context);

              final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
              if (await bloc.isGroupOnboardingActive && context.mounted) {
                setGroupOnboardingAsFinished(context);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    }
    // Dieser Screen wird dem Nutzer in der Regel nicht angezeigt, ist hier aber
    // für ein korrektes StateManagement. Also in der Regel wird die
    // GroupJoinCourseSelectionPage gelffnet, sodass dieser Screen gar nicht zu sehen ist.
    if (groupJoinResult is RequireCourseSelectionsJoinResult) {
      return StateSheetContent(
        body: RequireCourseSelectionsJoinResultDialog(result: groupJoinResult),
        actions: [
          ActionItem(
            title: "Kurse auswählen",
            onSelect: () {
              openGroupJoinCourseSelectionPage(context, groupJoinResult);
            },
          ),
        ],
      );
    }
    if (groupJoinResult is ErrorJoinResult) {
      return StateSheetContent(
        body: ErrorJoinResultDialog(errorJoinResult: groupJoinResult),
        actions: [
          ActionItem(
            title: "Nochmal versuchen",
            onSelect: () => groupJoinBloc.retry(),
          ),
        ],
      );
    }

    return const StateSheetContent(body: LoadingJoinResultDialog());
  }

  Future<void> show(BuildContext context) {
    hideKeyboard(context: context);
    final joinResultStream = groupJoinBloc.joinResult;
    final stateSheetContentStream = joinResultStream.map((joinResult) =>
        mapStateSheetContentFromJoinResult(joinResult, context));
    joinResultStream.listen((joinResult) {
      if (joinResult is RequireCourseSelectionsJoinResult) {
        openGroupJoinCoursePageIfNotYetOpen(context, joinResult);
      }
    });
    final stateSheet = StateSheet(stateSheetContentStream);

    return stateSheet.showSheet(context);
  }

  void setGroupOnboardingAsFinished(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    bloc.finishOnboarding();
  }

  var _hasOpenedCourseSelectionPage = false;

  void openGroupJoinCoursePageIfNotYetOpen(
      BuildContext context, RequireCourseSelectionsJoinResult joinResult) {
    if (!_hasOpenedCourseSelectionPage) {
      _hasOpenedCourseSelectionPage = true;
      openGroupJoinCourseSelectionPage(context, joinResult);
    }
  }
}
