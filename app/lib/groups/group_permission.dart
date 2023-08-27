// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:group_domain_models/group_domain_models.dart';

enum GroupPermission {
  /// Permission to perform administrative tasks for the group and its content.
  ///
  /// For example: editing course names/settings or editing homework created by
  /// another user in the group.
  administration,

  /// Permission to create content for the group (homework, info sheets, etc).
  ///
  /// In some places in the code this is also used to check if certain content
  /// can be edited, even if created by other users (timetable entry).
  /// There might be more usages than just strictly content creation.
  contentCreation,
}

extension HasRolePermission on MemberRole {
  bool hasPermission(GroupPermission permission) {
    return _hasPermission(permission, currentRole: this);
  }
}

bool _hasPermission(
  GroupPermission permissionType, {
  required MemberRole? currentRole,
}) {
  if (currentRole == null) return true;
  switch (permissionType) {
    case GroupPermission.administration:
      return [MemberRole.owner, MemberRole.admin].contains(currentRole);
    case GroupPermission.contentCreation:
      return [MemberRole.owner, MemberRole.admin, MemberRole.creator]
          .contains(currentRole);
  }
}

bool isUserAdminOrOwnerOfGroup(MemberRole? role) =>
    role == MemberRole.admin || role == MemberRole.owner;
