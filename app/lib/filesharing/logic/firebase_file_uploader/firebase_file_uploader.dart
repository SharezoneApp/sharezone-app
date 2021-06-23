import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/file_uploader.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';
import 'implementation/firebase_file_uploader_impl.dart';

class FirebaseFileUploader {
  final FirebaseFirestore _firestore;
  FirebaseFileUploader({@required FirebaseFirestore firestore})
      : _firestore = firestore;

  FirebaseFileUploaderImplementation get implementation =>
      FirebaseFileUploaderImplementation(firestore: _firestore);

  Future<UploadTask> uploadFile(
      {LocalFile localFile,
      String courseID,
      FolderPath path,
      String creatorID,
      String creatorName}) async {
    return implementation.uploadFile(
        localFile: localFile,
        courseID: courseID,
        path: path,
        creatorID: creatorID,
        creatorName: creatorName);
  }
}
