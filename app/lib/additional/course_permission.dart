import 'package:meta/meta.dart';
import 'package:group_domain_models/group_domain_models.dart';

/*
THIS DEFINES THE TYPE OF ACCESS
IN [requestPermission] the required Roles are listed
*/
enum PermissionAccessType {
  admin,
  creator, // DEFAULT ROLES
  memberManagement,
  courseEdit,
}

bool requestPermission(
    {@required MemberRole role,
    @required PermissionAccessType permissiontype}) {
  if (role == null) return true;
  switch (permissiontype) {
    case PermissionAccessType.admin:
      {
        return [MemberRole.owner, MemberRole.admin].contains(role);
      }
    case PermissionAccessType.creator:
      {
        return [MemberRole.owner, MemberRole.admin, MemberRole.creator]
            .contains(role);
      }
    case PermissionAccessType.memberManagement:
      {
        return [MemberRole.owner, MemberRole.admin].contains(role);
      }
    case PermissionAccessType.courseEdit:
      {
        return [
          MemberRole.owner,
          MemberRole.admin,
          MemberRole.creator,
        ].contains(role);
      }
  }
  return false;
}

bool isUserAdminOrOwnerFromCourse(MemberRole role) {
  if (role == MemberRole.admin || role == MemberRole.owner)
    return true;
  else
    return false;
}
