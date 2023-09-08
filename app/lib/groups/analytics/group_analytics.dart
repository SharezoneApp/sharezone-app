// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:group_domain_models/group_domain_models.dart';

class GroupAnalytics extends BlocBase {
  final Analytics _analytics;

  GroupAnalytics(this._analytics);

  void logEnableMeeting() {
    _analytics.log(GroupEvent('enable_meeting'));
  }

  void logDisbaleMeeting() {
    _analytics.log(GroupEvent('disable_meeting'));
  }

  void logChangedWritePermission(
    WritePermission permission, {
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'changed_write_permission',
      data: {
        'permission': permission.name,
        'groupType': groupType.name,
      },
    ));
  }

  void logUpdateMemberRole(
    MemberRole role, {
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'updated_member_role',
      data: {
        'role': role.name,
        'groupType': groupType.name,
      },
    ));
  }

  void logChangeGroupVisibility({
    required bool isPublic,
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'changed_group_visibility',
      data: {
        'visibility': isPublic ? 'public' : 'private',
        'groupType': groupType.name,
      },
    ));
  }

  void logKickedMember({
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'kicked_member',
      data: {
        'groupType': groupType.name,
      },
    ));
  }

  void logDeletedGroup({
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'deleted_group',
      data: {
        'groupType': groupType.name,
      },
    ));
  }

  void logLeftGroup({
    required GroupType groupType,
  }) {
    _analytics.log(GroupEvent(
      'left_group',
      data: {
        'groupType': groupType.name,
      },
    ));
  }

  @override
  void dispose() {}
}

class GroupEvent extends AnalyticsEvent {
  GroupEvent(String name, {Map<String, dynamic>? data})
      : super('group_$name', data: data);
}
