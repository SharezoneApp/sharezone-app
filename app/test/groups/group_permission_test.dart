// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/groups/group_permission.dart';

void main() {
  group('HasRolePermission', () {
    group('hasPermission for administration', () {
      test('should be true for owner', () {
        expect(MemberRole.owner.hasPermission(GroupPermission.administration),
            isTrue);
      });

      test('should be true for admin', () {
        expect(MemberRole.admin.hasPermission(GroupPermission.administration),
            isTrue);
      });

      test('should be false for creator', () {
        expect(MemberRole.creator.hasPermission(GroupPermission.administration),
            isFalse);
      });

      test('should be false for standard', () {
        expect(
            MemberRole.standard.hasPermission(GroupPermission.administration),
            isFalse);
      });
    });

    group('hasPermission for contentCreation', () {
      test('should be true for owner', () {
        expect(MemberRole.owner.hasPermission(GroupPermission.contentCreation),
            isTrue);
      });

      test('should be true for admin', () {
        expect(MemberRole.admin.hasPermission(GroupPermission.contentCreation),
            isTrue);
      });

      test('should be true for creator', () {
        expect(
            MemberRole.creator.hasPermission(GroupPermission.contentCreation),
            isTrue);
      });

      test('should be false for standard', () {
        expect(
            MemberRole.standard.hasPermission(GroupPermission.contentCreation),
            isFalse);
      });
    });
  });

  group('isUserAdminOrOwnerOfGroup', () {
    test('should be true for owner', () {
      expect(isUserAdminOrOwnerOfGroup(MemberRole.owner), isTrue);
    });

    test('should be true for admin', () {
      expect(isUserAdminOrOwnerOfGroup(MemberRole.admin), isTrue);
    });

    test('should be false for creator', () {
      expect(isUserAdminOrOwnerOfGroup(MemberRole.creator), isFalse);
    });

    test('should be false for standard', () {
      expect(isUserAdminOrOwnerOfGroup(MemberRole.standard), isFalse);
    });

    test('should be false for null role', () {
      expect(isUserAdminOrOwnerOfGroup(null), isFalse);
    });
  });
}
