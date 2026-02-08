// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/group_onboarding/pages/group_onboarding_page_template.dart';
import 'package:sharezone/onboarding/group_onboarding/widgets/hint_text.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';
import '../widgets/text_button.dart';
import 'create_schoolclass.dart';
import 'is_schoolclass_teacher.dart';
import 'join_group.dart';

class GroupOnboardingIsItFirstPersonUsingSharezone extends StatelessWidget {
  static const tag = 'group-onboarding-is-it-first-person-using-sharezone';

  const GroupOnboardingIsItFirstPersonUsingSharezone({super.key});

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingPageTemplate(
      title: _getString(context),
      bottomNavigationBar: SafeArea(
        child: GroupOnboardingHintText(
          context.l10n.groupOnboardingFirstPersonHint,
        ),
      ),
      children: const [_JoinGroupButton(), _CreateGroupsButton()],
    );
  }

  String _getString(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    switch (bloc.typeOfUser) {
      case TypeOfUser.student:
        return context.l10n.groupOnboardingFirstPersonStudentTitle;
      case TypeOfUser.parent:
        return context.l10n.groupOnboardingFirstPersonParentTitle;
      case TypeOfUser.teacher:
      default:
        return context.l10n.groupOnboardingFirstPersonTeacherTitle;
    }
  }
}

class _JoinGroupButton extends StatelessWidget {
  const _JoinGroupButton();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
    return GroupOnboardingTextButton(
      icon: const Icon(Icons.vpn_key),
      text:
          bloc.isStudent
              ? context.l10n.groupOnboardingJoinSingleGroupAction
              : context.l10n.groupOnboardingJoinMultipleGroupsAction,
      onTap:
          () => Navigator.push(
            context,
            FadeRoute(
              child: const GroupOnboardingGroupJoinPage(),
              tag: GroupOnboardingGroupJoinPage.tag,
            ),
          ),
    );
  }
}

class _CreateGroupsButton extends StatelessWidget {
  const _CreateGroupsButton();

  @override
  Widget build(BuildContext context) {
    return GroupOnboardingTextButton(
      icon: const Icon(Icons.add_circle_outline),
      text: context.l10n.groupOnboardingCreateNewGroupsAction,
      onTap: () {
        final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
        if (bloc.isTeacher) {
          Navigator.push(
            context,
            FadeRoute(
              child: const GroupOnboardingIsClassTeacher(),
              tag: GroupOnboardingIsClassTeacher.tag,
            ),
          );
        } else {
          Navigator.push(
            context,
            FadeRoute(
              child: const GroupOnboardingCreateSchoolClass(),
              tag: GroupOnboardingCreateSchoolClass.tag,
            ),
          );
        }
      },
    );
  }
}
