import 'package:sharezone_common/helper_functions.dart';

enum ReferenceType { homework, blackboard }
ReferenceType referenceTypeEnumFromString(String data) =>
    enumFromString(ReferenceType.values, data);
String referenceTypeEnumToString(ReferenceType referenceType) =>
    enumToString(referenceType);
