import 'package:sharezone_common/helper_functions.dart';

enum GroupType { course, schoolclass, school }

GroupType groupTypeFromString(String data) =>
    enumFromString(GroupType.values, data, orElse: GroupType.course);
String groupTypeToString(GroupType groupType) => enumToString(groupType);
