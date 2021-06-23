import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_compression.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:filesharing_logic/src/models/content_disposition.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb;
import '../file_uploader.dart';
import '../models/upload_meta_data.dart';
import '../models/upload_task.dart';
import '../models/upload_task_event.dart';
import '../models/upload_task_snapshot.dart';
import '../models/upload_task_type.dart';

class MobileFirebaseFileUploader extends FileUploader {
  @override
  Future<UploadTask> uploadFile({CloudFile cloudFile, LocalFile file}) async {
    final fileType = FileUtils.getFileFormatFromMimeType(file.getType());
    final storageReference = fb.FirebaseStorage.instance
        .ref()
        .child("files")
        .child(cloudFile.courseID)
        .child(cloudFile.id);

    if (fileType == FileFormat.image) {
      try {
        // final hasStoragePermissions = await _checkStoragePermission();
        // if (hasStoragePermissions) {
        final imageCompressor = getImageCompressor();
        final compressedFile = await imageCompressor.compressImage(file);
        if (compressedFile != null) file = compressedFile;
        // }
      } catch (e) {}
    }

    final uploadTask = storageReference.putFile(
      file.getFile(),
      fb.SettableMetadata(
        contentDisposition: getContentDispositionString(cloudFile.name),
        contentType: file.getType().toData(),
        customMetadata: cloudFile.toMetaData().toJson(),
      ),
    );

    return _uploadTaskFromFirebase(uploadTask);
  }

  UploadTask _uploadTaskFromFirebase(fb.UploadTask uploadTask) {
    return UploadTask(
      onComplete: uploadTask.then(
          (taskSnapshot) => _uploadTaskSnapshotFromFirebase(taskSnapshot)),
      events: uploadTask.snapshotEvents
          .map((taskSnapshot) => _uploadTaskEventFromFirebase(taskSnapshot)),
    );
  }

  UploadTaskSnapshot _uploadTaskSnapshotFromFirebase(
      fb.TaskSnapshot taskSnpashot) {
    return UploadTaskSnapshot(
      storageMetaData: UploadMetadata(
        customMetadata: taskSnpashot.metadata.customMetadata,
        sizeBytes: taskSnpashot.metadata.size,
      ),
      totalByteCount: taskSnpashot.totalBytes,
      bytesTransferred: taskSnpashot.bytesTransferred,
      getDownloadUrl: () => taskSnpashot.ref.getDownloadURL(),
    );
  }

  UploadTaskEvent _uploadTaskEventFromFirebase(fb.TaskSnapshot taskSnapshot) {
    return UploadTaskEvent(
      snapshot: _uploadTaskSnapshotFromFirebase(taskSnapshot),
      type: _uploadTaskEventTypeFromFirebase(taskSnapshot.state),
    );
  }

  UploadTaskEventType _uploadTaskEventTypeFromFirebase(fb.TaskState taskState) {
    switch (taskState) {
      case fb.TaskState.error:
        return UploadTaskEventType.error;
      case fb.TaskState.paused:
        return UploadTaskEventType.running;
      case fb.TaskState.running:
        return UploadTaskEventType.running;
      case fb.TaskState.canceled:
        return UploadTaskEventType.canceled;
      case fb.TaskState.success:
        return UploadTaskEventType.success;
    }
    throw UnimplementedError(
        'Could not find a UploadTaskEventType for $taskState');
  }

  @override
  Future<UploadTask> uploadFileToStorage(
      CloudStoragePfad cloudStoragePfad, String creatorId, LocalFile localFile,
      {String cacheControl}) async {
    if (!cloudStoragePfad.istDateiPfad) {
      throw ArgumentError.value(
          cloudStoragePfad, 'cloudStoragePfad', 'muss ein Dateipfad sein.');
    }
    final fileId = cloudStoragePfad.uri.pathSegments.last;
    final fileType = FileUtils.getFileFormatFromMimeType(localFile.getType());
    final storage =
        fb.FirebaseStorage.instanceFor(bucket: cloudStoragePfad.bucket.name);
    final storageReference = storage.ref().child(cloudStoragePfad.lokalerPfad);

    /// Bei der Kompression wird der Dateiname verändert, wir wollen aber den
    /// originalen benutzen,
    final originalerName = localFile.getName();

    if (fileType == FileFormat.image) {
      try {
        // final hasStoragePermissions = await _checkStoragePermission();
        // if (hasStoragePermissions) {
        final imageCompressor = getImageCompressor();
        final compressedFile = await imageCompressor.compressImage(localFile);
        if (compressedFile != null) localFile = compressedFile;
        // }
      } catch (e) {}
    }

    final uploadTask = storageReference.putFile(
      localFile.getFile(),
      fb.SettableMetadata(
        contentDisposition: getContentDispositionString(originalerName),
        contentType: localFile.getType().toData(),
        cacheControl: cacheControl,
        customMetadata: {
          'fileID': fileId,
          'fileName': originalerName,
          'creatorID': creatorId
        },
      ),
    );
    return _uploadTaskFromFirebase(uploadTask);
  }
}

FileUploader getFileUploaderImplementation() {
  return MobileFirebaseFileUploader();
}
