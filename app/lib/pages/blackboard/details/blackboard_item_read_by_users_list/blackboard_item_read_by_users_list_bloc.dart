import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/models/blackboard_item.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone_common/references.dart';
import 'package:user/user.dart';

import 'user_view.dart';

class BlackboardItemReadByUsersListBloc extends BlocBase {
  final String _itemId;
  final CourseId _courseId;
  final BlackboardGateway _gateway;
  final CollectionReference _courseRef;

  BlackboardItemReadByUsersListBloc(
    this._itemId,
    this._gateway,
    this._courseRef,
    this._courseId,
  );

  Stream<List<UserView>> get userViews {
    return _gateway.singleBlackboardItem(_itemId).asyncMap(_mapToViews);
  }

  Future<List<UserView>> _mapToViews(BlackboardItem item) async {
    final views = <UserView>[];

    for (final userId in item.forUsers.keys) {
      if (userId != item.authorID) {
        final membersDoc = await _courseRef
            .doc('$_courseId')
            .collection(CollectionNames.members)
            .doc(userId)
            .get();
        final user = MemberData.fromData(membersDoc.data(), id: userId);
        final hasRead = item.forUsers[userId];
        views.add(user.toView(hasRead));
      }
    }

    return views.sortViewsFirstByTypeOfUserSecondByAlphabet();
  }

  @override
  void dispose() {}
}

extension on MemberData {
  UserView toView(bool hasRead) {
    return UserView(
      uid: '$id',
      name: name,
      hasRead: hasRead,
      typeOfUser: typeOfUser.toReadableString(),
    );
  }
}

extension ImprovedSorting on List<UserView> {
  /// Gibt aus einer Liste mit UserViews alle User zurück, die dem [typeOfUser]
  /// entsprechen. Zudem wird diese Liste direkt alphabetisch sortiert.
  List<UserView> getViewsOfTypeOfUserSortedAlphabetically(
      TypeOfUser typeOfUser) {
    return where((user) => user.typeOfUser == typeOfUser.toReadableString())
        .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Gibt eine neue Liste zurück, die nach [TypeOfUser] sortiert ist. Die Sortierung
  /// ist Lehrer, Schüler und zum Schluss Eltern.
  List<UserView> sortViewsFirstByTypeOfUserSecondByAlphabet() {
    return [
      ...getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.teacher),
      ...getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.student),
      ...getViewsOfTypeOfUserSortedAlphabetically(TypeOfUser.parent)
    ];
  }
}
