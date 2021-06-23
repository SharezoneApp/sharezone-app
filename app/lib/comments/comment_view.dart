import 'misc.dart';

class CommentView {
  final String id;
  final String content;
  final String avatarAbbreviation;
  final String commentAge;
  final String userName;
  final CommentStatus status;
  final String likes;
  final bool hasPermissionsToManageComments;

  CommentView({
    this.content = "",
    this.avatarAbbreviation = "",
    this.commentAge = "",
    this.userName = "",
    this.status = CommentStatus.notRated,
    this.hasPermissionsToManageComments = false,
    this.likes = "0",
    this.id = "",
  });
}
