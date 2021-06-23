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
