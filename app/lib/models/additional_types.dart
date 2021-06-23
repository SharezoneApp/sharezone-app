import 'package:sharezone_common/helper_functions.dart';

// ProfileDisplayMode
enum ProfileDisplayMode { pic, avatar, none }
ProfileDisplayMode profileDisplayModeEnumFromString(String data) =>
    enumFromString(ProfileDisplayMode.values, data);
String profileDisplayModeEnumToString(ProfileDisplayMode displayMode) =>
    enumToString(displayMode);
