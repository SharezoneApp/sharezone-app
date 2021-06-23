import 'package:bloc_base/bloc_base.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';

class FileSharingPageBloc extends BlocBase {
  final FileSharingGateway _gateway;

  Stream<List<FileSharingData>> get courseFolders =>
      _gateway.courseFoldersStream();

  Stream<FileSharingData> courseFolder(String courseID) {
    return _gateway.folderGateway.folderStream(courseID);
  }

  Stream<List<CloudFile>> fileQuery(String courseID, FolderPath folderPath) {
    return _gateway.cloudFilesGateway.filesStreamFolder(courseID, folderPath);
  }

  Stream<List<CloudFile>> fileQueryMySubmission(
      String courseID, FolderPath folderPath) {
    return _gateway.cloudFilesGateway
        .filesStreamFolder(courseID, folderPath.getChildPath(_gateway.uID));
  }

  Stream<List<CloudFile>> fileQueryWithSubPaths(
      String courseID, FolderPath folderPath) {
    return _gateway.cloudFilesGateway
        .filesStreamFolderAndSubFolders(courseID, folderPath);
  }

  FileSharingPageBloc(this._gateway);

  @override
  void dispose() {}
}
