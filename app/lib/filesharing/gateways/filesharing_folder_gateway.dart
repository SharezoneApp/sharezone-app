import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filesharing_logic/filesharing_gateways.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';

import 'package:sharezone/filesharing/logic/firebase_file_uploader/firebase_file_uploader.dart';

class FilesharingFolderGateway implements FolderAccessor, FolderOperator {
  final AuthUser user;
  final String uID;
  CollectionReference get fileSharingCollection =>
      _fStore.collection("FileSharing");
  final FirebaseFirestore _fStore;
  final FirebaseFileUploader fileUploader;

  FilesharingFolderGateway(
      {@required this.user, @required FirebaseFirestore firestore})
      : uID = user.uid,
        _fStore = firestore,
        fileUploader = FirebaseFileUploader(firestore: firestore);

  @override
  Future<void> createFolder(
      String courseID, FolderPath folderPath, Folder folder) {
    return fileSharingCollection.doc(courseID).set(
        folderPath.getFolderDocumentMap(folder.id, folder.toJson()),
        SetOptions(merge: true));
  }

  @override
  Future<void> deleteFolder(
      String courseID, FolderPath folderPath, Folder folder) {
    if (folderPath == FolderPath.root && folder.id == 'attachment') return null;
    return fileSharingCollection.doc(courseID).set(
        folderPath.getFolderDocumentMap(folder.id, FieldValue.delete()),
        SetOptions(merge: true));
  }

  @override
  Future<void> editFolder(
      String courseID, FolderPath folderPath, Folder folder) {
    return fileSharingCollection.doc(courseID).set(
        folderPath.getFolderDocumentMap(folder.id, folder.toJson()),
        SetOptions(merge: true));
  }

  @override
  Stream<FileSharingData> folderStream(String courseID) {
    return fileSharingCollection.doc(courseID).snapshots().map((snapshot) =>
        FileSharingData.fromData(id: snapshot.id, data: snapshot.data()));
  }

  @override
  Future<FileSharingData> getFilesharingData(String courseID) {
    return fileSharingCollection.doc(courseID).get().then((snapshot) =>
        FileSharingData.fromData(id: snapshot.id, data: snapshot.data()));
  }

  @override
  Future<void> renameFolder(
      String courseID, FolderPath folderPath, Folder folder) {
    return fileSharingCollection.doc(courseID).set(
        folderPath.getFolderDocumentMap(folder.id, {
          'name': folder.name,
        }),
        SetOptions(merge: true));
  }
}
