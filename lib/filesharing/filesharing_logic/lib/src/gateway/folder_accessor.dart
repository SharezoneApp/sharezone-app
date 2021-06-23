import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class FolderAccessor {
  Stream<FileSharingData> folderStream(String courseID);

  Future<FileSharingData> getFilesharingData(String courseID);
}
