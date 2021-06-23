import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';

abstract class FileSharingPageState {}

class FileSharingPageStateHome extends FileSharingPageState {}

class FileSharingPageStateGroup extends FileSharingPageState {
  final String groupID;
  final FolderPath path;
  final FileSharingData initialFileSharingData;

  FileSharingPageStateGroup({
    @required this.groupID,
    @required this.path,
    @required this.initialFileSharingData,
  });
}
