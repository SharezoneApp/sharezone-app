// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

abstract class GroupJoinException {}

class UnknownGroupJoinException implements GroupJoinException {
  final dynamic exception;
  UnknownGroupJoinException({this.exception});
}

class NoInternetGroupJoinException implements GroupJoinException {}

class GroupNotPublicGroupJoinException implements GroupJoinException {}

class AlreadyMemberGroupJoinException implements GroupJoinException {}

class SharecodeNotFoundGroupJoinException implements GroupJoinException {
  final String enteredSharecode;

  const SharecodeNotFoundGroupJoinException(this.enteredSharecode);
}
