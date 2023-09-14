// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Even "successfull" is a typo, it's the name of the event in the backend and
// we can't change it.
const _successful = 'successfull';
const _notPublic = 'notpublic';
const _notFound = 'notfound';
const _alreadyMember = 'alreadymember';
const _requireCourseSelections = 'requirecourseselections';
const _unknown = 'unknown';

enum GroupJoinResultType {
  successful,
  notPublic,
  notFound,
  alreadyMember,
  requireCourseSelections,
  unknown
}

extension GroupJoinResultTypeConverter on GroupJoinResultType {
  static GroupJoinResultType fromData(String data) {
    switch (data) {
      case _successful:
        return GroupJoinResultType.successful;
      case _notPublic:
        return GroupJoinResultType.notPublic;
      case _notFound:
        return GroupJoinResultType.notFound;
      case _alreadyMember:
        return GroupJoinResultType.alreadyMember;
      case _requireCourseSelections:
        return GroupJoinResultType.requireCourseSelections;
    }
    return GroupJoinResultType.unknown;
  }

  String toData() {
    switch (this) {
      case GroupJoinResultType.successful:
        return _successful;
      case GroupJoinResultType.notPublic:
        return _notPublic;
      case GroupJoinResultType.notFound:
        return _notFound;
      case GroupJoinResultType.alreadyMember:
        return _alreadyMember;
      case GroupJoinResultType.requireCourseSelections:
        return _requireCourseSelections;
      default:
        return _unknown;
    }
  }
}
