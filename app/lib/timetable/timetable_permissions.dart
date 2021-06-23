import 'package:sharezone/additional/course_permission.dart';
import 'package:group_domain_models/group_domain_models.dart';

/// User has to be a creator and a teacher or student
bool hasPermissionToManageLessons(MemberRole myRole) {
  return requestPermission(
      role: myRole, permissiontype: PermissionAccessType.creator);
}

bool hasPermissionToManageEvents(MemberRole myRole, bool isAuthor) {
  return isAuthor ||
      requestPermission(
          role: myRole, permissiontype: PermissionAccessType.admin);
}
