import 'package:sharezone_common/helper_functions.dart';

enum MemberRole {
  owner,
  admin,
  creator,
  standard,
  none,
}
MemberRole memberRoleEnumFromString(String data) =>
    enumFromString(MemberRole.values, data);
String memberRoleEnumToString(MemberRole memberRole) =>
    enumToString(memberRole);
const Map<MemberRole, String> memberRoleAsString = {
  MemberRole.admin: "Admin",
  MemberRole.creator: "Aktives Mitglied (Schreib- und Leserechte)",
  MemberRole.standard: "Passives Mitglied (Nur Leserechte)",
  MemberRole.owner: "Besitzer",
  MemberRole.none: "Nichts",
};
