// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/comments/comment_data_models.dart';
import 'package:sharezone/comments/misc.dart';

const _liked = "likedBy";
const _disliked = "dislikedBy";

class CommentsGateway extends BlocBase {
  final FirebaseFirestore _firestore;
  final Map<CommentsLocation, StreamController<List<CommentDataModel>>>
      _commentsControllers = {};

  CommentsGateway(this._firestore);

  Stream<List<CommentDataModel>> comments(CommentsLocation commentLocation) {
    // Getting closed in `dispose`
    // ignore: close_sinks
    var commentsController = _commentsControllers[commentLocation];

    late StreamSubscription firestoreSubscription;
    commentsController ??= StreamController.broadcast(onListen: () {
      final snapshotStream = _getCommentCollection(commentLocation).snapshots();

      final commentModelDataStream = snapshotStream.map((snap) => snap.docs
          .map((doc) => _commentToDatamodel(doc.data(), id: doc.id))
          .toList());

      firestoreSubscription = commentModelDataStream.listen(
          commentsController!.add,
          onError: commentsController.addError,
          cancelOnError: false);
    }, onCancel: () {
      firestoreSubscription.cancel();
    });
    return commentsController.stream;
  }

  CommentDataModel _commentToDatamodel(
    Map<String, dynamic> firestoreComment, {
    required String id,
  }) =>
      CommentDataModel.fromFirestore(firestoreComment, id: id);

  CollectionReference<Map<String, dynamic>> _getCommentCollection(
      CommentsLocation commentLocation) {
    return _firestore
        .collection(commentLocation.baseCollection)
        .doc(commentLocation.parentDocumentId)
        .collection("comments");
  }

  void add(CommentDataModel comment, CommentsLocation commentLocation) {
    _getCommentCollection(commentLocation).add(comment.toFirestore());
  }

  Future<void> changeRating(String uid, CommentLocation commentLocation,
      CommentStatus oldStatus, CommentStatus newStatus) async {
    final action = StatusChanger(oldStatus, newStatus).getAction();
    final docRef = _firestore.doc(commentLocation.path);
    await action.execute(docRef, uid);
  }

  void delete(CommentLocation commentLocation) {
    _firestore.doc(commentLocation.path).delete();
  }

  @override
  void dispose() {
    _commentsControllers.forEach((_, controller) => controller.close());
  }
}

enum RatingOperation { add, delete }

enum RatingField { like, dislike }

/// Die "Stelle", wo alle zugehörige Kommentare gespeichert werden.
class CommentsLocation {
  final CommentOnType commentOnType;
  final String baseCollection;
  final String parentDocumentId;

  static const _commentOnTypeToString = {
    CommentOnType.homework: "Homework",
    CommentOnType.blackboard: "Blackboard",
  };

  String get path => "$baseCollection/$parentDocumentId/comments";

  CommentsLocation({
    required this.commentOnType,
    required this.parentDocumentId,
  }) : baseCollection = _commentOnTypeToString[commentOnType]! {
    ArgumentError.checkNotNull(parentDocumentId, 'parentDocumentId');
    if (parentDocumentId.isEmpty) {
      throw ArgumentError('parentDocumentId cant be an empty string');
    }
  }
}

/// Die "Stelle", wo ein einziges Kommentar gespeichert wird.
class CommentLocation extends CommentsLocation {
  final String commentId;

  @override
  String get path => "${super.path}/$commentId";

  CommentLocation({
    required this.commentId,
    required CommentOnType commentOnType,
    required String parentDocumentId,
  }) : super(commentOnType: commentOnType, parentDocumentId: parentDocumentId);

  CommentLocation.fromCommentsLocation({
    required CommentsLocation commentsLocation,
    required this.commentId,
  }) : super(
          commentOnType: commentsLocation.commentOnType,
          parentDocumentId: commentsLocation.parentDocumentId,
        );
}

enum CommentOnType { homework, blackboard }

class StatusChanger {
  final CommentStatus _oldStatus;
  final CommentStatus _newStatus;

  StatusChanger(this._oldStatus, this._newStatus);

  RatingAction getAction() {
    if (_oldStatus == _newStatus) return NullRatingAction();
    if (_newStatus == CommentStatus.notRated) {
      return SingularRatingAction.delete(_rateFieldToGet(_oldStatus));
    }
    if (_oldStatus == CommentStatus.notRated) {
      return SingularRatingAction.add(_rateFieldToGet(_newStatus));
    }
    // _oldstatus is the opposite of _newStatus
    if (_newStatus == CommentStatus.liked) {
      return MultiRatingActions([
        SingularRatingAction.delete(RatingField.dislike),
        SingularRatingAction.add(RatingField.like)
      ]);
    }
    if (_newStatus == CommentStatus.disliked) {
      return MultiRatingActions([
        SingularRatingAction.delete(RatingField.like),
        SingularRatingAction.add(RatingField.dislike)
      ]);
    }
    // If any1 sees this: I fucked up.
    throw Error();
  }

  RatingField _rateFieldToGet(CommentStatus status) {
    switch (status) {
      case CommentStatus.liked:
        return RatingField.like;
      case CommentStatus.disliked:
        return RatingField.dislike;
      default:
        throw Error();
    }
  }
}

// ignore:one_member_abstracts
abstract class RatingAction {
  Future<void> execute(DocumentReference commentLocation, String uid);
}

/// Ist dafür da, dass man z.B. von einem Like zu Dislike in einer Transaktion
/// gehen kann, ohne, dass das Rating erst positiv und negativ ist und dann
/// nur negativ ist, sondern der Wechsel von positiv zu negativ direkt passiert.
class MultiRatingActions extends RatingAction {
  final List<SingularRatingAction> actions;

  MultiRatingActions(this.actions);

  @override
  Future<void> execute(DocumentReference commentLocation, String uid) async {
    final _firestore = commentLocation.firestore;
    await _firestore.runTransaction((transaction) async {
      for (final action in actions) {
        await action.execute(commentLocation, uid, transaction);
      }
    });
  }
}

class SingularRatingAction extends RatingAction {
  final RatingField _field;
  final RatingOperation _operation;

  @override
  Future<void> execute(DocumentReference commentLocation, String uid,
      [Transaction? transaction]) async {
    final arrayField = _getCorrespondingArrayName(_field);
    final arrayOperation = _operation == RatingOperation.add
        ? FieldValue.arrayUnion([uid])
        : FieldValue.arrayRemove([uid]);
    final data = {
      arrayField: arrayOperation,
    };
    if (transaction != null) {
      transaction.update(commentLocation, data);
    } else {
      await commentLocation.update(data);
    }
  }

  SingularRatingAction(this._field, this._operation);
  SingularRatingAction.delete(this._field)
      : _operation = RatingOperation.delete;
  SingularRatingAction.add(this._field) : _operation = RatingOperation.add;
}

class NullRatingAction extends RatingAction {
  @override
  Future<void> execute(DocumentReference commentLocation, String uid) {
    return Future.value();
  }
}

String _getCorrespondingArrayName(RatingField rf) =>
    rf == RatingField.like ? _liked : _disliked;
