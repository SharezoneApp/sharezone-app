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
