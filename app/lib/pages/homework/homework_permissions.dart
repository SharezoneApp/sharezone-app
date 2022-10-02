// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/additional/course_permission.dart';

/// User  has to be a creator and a teacher or student
bool hasPermissionToManageHomeworks(MemberRole myRole, bool isAuthor) {
  return isAuthor ||
      requestPermission(
          role: myRole, permissionType: PermissionAccessType.admin);
}
