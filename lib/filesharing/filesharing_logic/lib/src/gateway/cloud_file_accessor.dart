import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class CloudFileAccessor {
  Stream<List<CloudFile>> filesStreamFolder(String courseID, FolderPath path);

  Stream<List<CloudFile>> filesStreamFolderAndSubFolders(
      String courseID, FolderPath path);

  Stream<List<CloudFile>> filesStreamAttachment(
      String courseID, String referenceID);

  Stream<CloudFile> cloudFileStream(String cloudFileID);

  Stream<String> nameStream(String cloudFileID);
}
