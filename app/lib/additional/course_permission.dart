// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';

/*
THIS DEFINES THE TYPE OF ACCESS
IN [requestPermission] the required Roles are listed
*/
enum PermissionAccessType {
  admin,

  /// DEFAULT ROLES - Creator as in "able to create/add homeworks etc.", not course creator
  creator,
}

extension HasRolePermission on MemberRole {
  bool hasPermission(PermissionAccessType permission) {
    return _hasPermission(permission, currentRole: this);
  }
}

bool _hasPermission(PermissionAccessType permissionType,
    {@required MemberRole currentRole}) {
  if (currentRole == null) return true;
  switch (permissionType) {
    case PermissionAccessType.admin:
      {
        return [MemberRole.owner, MemberRole.admin].contains(currentRole);
      }
    case PermissionAccessType.creator:
      {
        return [MemberRole.owner, MemberRole.admin, MemberRole.creator]
            .contains(currentRole);
      }
  }
  return false;
}

bool isUserAdminOrOwnerFromCourse(MemberRole role) {
  if (role == MemberRole.admin || role == MemberRole.owner)
    return true;
  else
    return false;
}
