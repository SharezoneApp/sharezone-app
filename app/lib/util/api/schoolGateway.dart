import 'package:app_functions/app_functions.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone_common/references.dart';

class SchoolGateway {
  final References references;
  final String memberID;
  final ConnectionsGateway _connectionsGateway;

  const SchoolGateway(this.references, this.memberID, this._connectionsGateway);

  Future<AppFunctionsResult<bool>> createSchool(SchoolData school) {
    return references.functions.groupCreate(
      memberID: memberID,
      id: school.id,
      data: school.toCreateJson(),
      type: groupTypeToString(GroupType.school),
    );
  }

  Future<AppFunctionsResult<bool>> leave(String schoolID) {
    return _connectionsGateway.leave(
      id: schoolID,
      type: GroupType.school,
    );
  }

  Future<AppFunctionsResult<bool>> edit(SchoolData schoolData) {
    return references.functions.groupEdit(
      id: schoolData.id,
      data: schoolData.toEditJson(),
      type: groupTypeToString(GroupType.school),
    );
  }

  Future<AppFunctionsResult<bool>> editSettings(
      String schoolID, CourseSettings schoolSettings) {
    return references.functions.groupEditSettings(
      id: schoolID,
      settings: schoolSettings.toJson(),
      type: groupTypeToString(GroupType.school),
    );
  }

  Future<AppFunctionsResult<bool>> kickMember(
      String schoolID, String kickedMemberID) async {
    return references.functions.leave(
      id: schoolID,
      type: groupTypeToString(GroupType.school),
      memberID: kickedMemberID,
    );
  }

  Stream<School> stream() {
    return ConnectionsGateway(references, memberID)
        .streamConnectionsData()
        .map((connections) => connections.school);
  }

  Stream<List<MemberData>> streamMembersData(String schoolID) {
    return references.schools
        .doc(schoolID)
        .collection(CollectionNames.members)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnap) =>
                MemberData.fromData(docSnap.data(), id: docSnap.id))
            .toList());
  }

  School current() => _connectionsGateway.current().school;
}
