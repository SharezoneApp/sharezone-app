// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

enum TypeOfUser { student, teacher, parent, tutor, unknown }

extension TypeOfUserExtension on TypeOfUser {
  bool get isTeacher => this == TypeOfUser.teacher;
  bool get isParent => this == TypeOfUser.parent;
  bool get isStudent => this == TypeOfUser.student;

  String toReadableString() {
    switch (this) {
      case TypeOfUser.student:
        return 'Schüler*in';
      case TypeOfUser.teacher:
        return 'Lehrkraft';
      case TypeOfUser.parent:
        return 'Elternteil';
      case TypeOfUser.tutor:
        return 'Nachhilfekraft';
      case TypeOfUser.unknown:
        return 'Unbekannt';
    }
    throw UnimplementedError('Unknown TypeOfUser: $this');
  }
}
