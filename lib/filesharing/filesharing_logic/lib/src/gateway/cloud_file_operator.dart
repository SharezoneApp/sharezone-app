import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class CloudFileOperator {
  Future<void> deleteFile(String courseID, String fileID);
  Future<void> renameFile(CloudFile file);
  Future<void> moveFile(CloudFile file, FolderPath newPath);
}
