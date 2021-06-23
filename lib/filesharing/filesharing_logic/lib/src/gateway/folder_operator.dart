import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class FolderOperator {
  Future<void> createFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> renameFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> deleteFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> editFolder(
      String courseID, FolderPath folderPath, Folder folder);
}
