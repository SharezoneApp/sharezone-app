import 'package:group_domain_models/group_domain_models.dart';

abstract class CourseMemberAccessor {
  Stream<List<MemberData>> streamAllMembers(String courseID);
  Stream<MemberData> streamSingleMember(String courseID, String memberID);
}
