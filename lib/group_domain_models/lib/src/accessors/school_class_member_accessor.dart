import 'package:group_domain_models/group_domain_models.dart';

abstract class SchoolClassMemberAccessor {
  Stream<List<MemberData>> streamAllMembers(String schoolClassID);
  Stream<MemberData> streamSingleMember(String schoolClassID, String memberID);
}
