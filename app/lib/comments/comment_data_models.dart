import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/comments/comment.dart';
import 'package:sharezone_common/helper_functions.dart';

class CommentDataModel {
  final String id;
  final String comment;
  final CommentAuthorDataModel author;
  final List<String> likedBy;
  final List<String> dislikedBy;
  final Timestamp writtenOn;

  const CommentDataModel({
    this.comment = "",
    this.author = const CommentAuthorDataModel(),
    this.likedBy = const [],
    this.dislikedBy = const [],
    this.writtenOn, // Will be ServerTimestamp
    this.id,
  });

  factory CommentDataModel.fromComment(Comment comment) {
    final commentAuthor = CommentAuthorDataModel(
      abbreviation: comment.author.abbreviation,
      name: comment.author.name,
      uid: comment.author.uid,
    );
    return CommentDataModel(
      id: comment.id,
      author: commentAuthor,
      comment: comment.content,
      dislikedBy: comment.negativeRatings.map((r) => r.uid).toList(),
      likedBy: comment.positiveRatings.map((r) => r.uid).toList(),
      writtenOn: Timestamp.fromDate(comment.age.writtenOnDateTime),
    );
  }

  factory CommentDataModel.fromFirestore(Map<String, dynamic> data,
      {@required String id}) {
    return CommentDataModel(
      id: id,
      author: CommentAuthorDataModel.fromFirestore(
          data["author"] as Map<String, dynamic>),
      comment: data["comment"] as String,
      dislikedBy: decodeList<String>(data["dislikedBy"], (kp) => kp as String),
      likedBy: decodeList<String>(data["likedBy"], (kp) => kp as String),
      writtenOn: data["writtenOn"] as Timestamp ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "comment": comment,
      "author": author.toFirestore(),
      "dislikedBy": dislikedBy,
      "likedBy": likedBy,
      "writtenOn": FieldValue.serverTimestamp(),
    };
  }

  Comment toModel() {
    return Comment(
      author: author.toModel(),
      content: comment,
      ratings: _createRatings(),
      age: CommentAge.fromDuration(
          DateTime.now().difference(writtenOn.toDate())),
      id: id,
    );
  }

  List<Rating> _createRatings() {
    final positiveRatings =
        likedBy.map((uid) => Rating.positive(uid: uid)).toList();
    final negativeRatings =
        dislikedBy.map((uid) => Rating.negative(uid: uid)).toList();
    return [...positiveRatings, ...negativeRatings];
  }
}

class CommentAuthorDataModel {
  final String abbreviation;
  final String name;
  final String uid;

  const CommentAuthorDataModel({
    this.abbreviation = "",
    this.name = "",
    this.uid = "",
  });

  Map<String, dynamic> toFirestore() {
    return {
      "abbreviation": abbreviation,
      "name": name,
      "uid": uid,
    };
  }

  factory CommentAuthorDataModel.fromFirestore(Map<String, dynamic> data) {
    return CommentAuthorDataModel(
      abbreviation: data["abbreviation"] as String,
      name: data["name"] as String,
      uid: data["uid"] as String,
    );
  }

  CommentAuthor toModel() {
    return CommentAuthor(uid: uid, name: name, abbreviation: abbreviation);
  }
}
