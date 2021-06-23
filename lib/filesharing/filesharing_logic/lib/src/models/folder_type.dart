import 'package:sharezone_common/helper_functions.dart';

enum FolderType { normal }
FolderType folderTypeFromString(String data) =>
    enumFromString(FolderType.values, data);
String folderTypeToString(FolderType folderType) => enumToString(folderType);
