// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

sealed class GroupJoinException {}

class UnknownGroupJoinException extends GroupJoinException {
  final dynamic exception;
  UnknownGroupJoinException({this.exception});
}

class NoInternetGroupJoinException extends GroupJoinException {}

class GroupNotPublicGroupJoinException extends GroupJoinException {}

class AlreadyMemberGroupJoinException extends GroupJoinException {}

class SharecodeNotFoundGroupJoinException extends GroupJoinException {
  final String enteredSharecode;

  SharecodeNotFoundGroupJoinException(this.enteredSharecode);
}
