import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/file_uploader.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';

class FirebaseFileUploaderImplementation {
  CollectionReference get filesCollection => _fStore.collection("Files");
  final FirebaseFirestore _fStore;

  const FirebaseFileUploaderImplementation(
      {@required FirebaseFirestore firestore})
      : _fStore = firestore;

  Future<UploadTask> uploadFile(
      {String courseID,
      FolderPath path,
      LocalFile localFile,
      String creatorID,
      String creatorName}) async {
    final ref = filesCollection.doc();
    final fileID = ref.id;
    final fileFormat = FileUtils.getFileFormatFromMimeType(localFile.getType());
    final cloudFile = CloudFile.create(
      id: fileID,
      creatorID: creatorID,
      creatorName: creatorName,
      courseID: courseID,
      path: path ?? FolderPath.root,
    ).copyWith(
      fileFormat: fileFormat,
      forUsers: {creatorID: true},
      changes: [
        ChangeActivity(
          authorID: creatorID,
          authorName: creatorName,
          changedOn: DateTime.now(),
        )
      ],
      name: localFile.getName(),
    );

    final fileUploder = getFileUploader();
    final uploadTask = await fileUploder.uploadFile(
      cloudFile: cloudFile,
      file: localFile,
    );

    await _saveCloudFileInFirestore(ref, cloudFile);

    uploadTask.onComplete.then((snapshot) async {
      final downloadURL = (await snapshot.getDownloadUrl()).toString();
      final cloudFileWithDownloadURL = cloudFile.copyWith(
        sizeBytes: snapshot.storageMetaData.sizeBytes,
        downloadURL: downloadURL,
      );
      await _saveCloudFileInFirestore(ref, cloudFileWithDownloadURL);
    });

    return uploadTask;
  }

  Future<void> _saveCloudFileInFirestore(
      DocumentReference reference, CloudFile cloudFile) async {
    await reference.set(cloudFile.toJson(), SetOptions(merge: true));
  }
}
