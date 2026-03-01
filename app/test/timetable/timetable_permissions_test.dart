// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';

void main() {
  group('hasPermissionToManageLessons', () {
    test('should be true for owner', () {
      expect(hasPermissionToManageLessons(MemberRole.owner), isTrue);
    });

    test('should be true for admin', () {
      expect(hasPermissionToManageLessons(MemberRole.admin), isTrue);
    });

    test('should be true for creator', () {
      expect(hasPermissionToManageLessons(MemberRole.creator), isTrue);
    });

    test('should be false for standard', () {
      expect(hasPermissionToManageLessons(MemberRole.standard), isFalse);
    });
  });

  group('hasPermissionToManageEvents', () {
    group('when user is author', () {
      test('should be true for owner', () {
        expect(hasPermissionToManageEvents(MemberRole.owner, true), isTrue);
      });

      test('should be true for admin', () {
        expect(hasPermissionToManageEvents(MemberRole.admin, true), isTrue);
      });

      test('should be true for creator', () {
        expect(hasPermissionToManageEvents(MemberRole.creator, true), isTrue);
      });

      test('should be true for standard', () {
        expect(hasPermissionToManageEvents(MemberRole.standard, true), isTrue);
      });
    });

    group('when user is not author', () {
      test('should be true for owner', () {
        expect(hasPermissionToManageEvents(MemberRole.owner, false), isTrue);
      });

      test('should be true for admin', () {
        expect(hasPermissionToManageEvents(MemberRole.admin, false), isTrue);
      });

      test('should be false for creator', () {
        expect(hasPermissionToManageEvents(MemberRole.creator, false), isFalse);
      });

      test('should be false for standard', () {
        expect(hasPermissionToManageEvents(MemberRole.standard, false), isFalse);
      });
    });
  });
}
