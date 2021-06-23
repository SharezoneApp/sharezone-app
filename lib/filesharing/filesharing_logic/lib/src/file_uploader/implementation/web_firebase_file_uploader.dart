import 'dart:typed_data';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:filesharing_logic/src/models/content_disposition.dart';
import 'package:firebase/firebase.dart' as firebase;
import '../file_uploader.dart';
import '../models/upload_meta_data.dart';
import '../models/upload_task.dart';
import '../models/upload_task_event.dart';
import '../models/upload_task_snapshot.dart';
import '../models/upload_task_type.dart';

class WebFirebaseFileUploader extends FileUploader {
  @override
  Future<UploadTask> uploadFile({CloudFile cloudFile, LocalFile file}) async {
    final path = 'files/${cloudFile.courseID}/${cloudFile.id}';
    final Uint8List fileBytes = file.getData();
    final ref = firebase.storage().ref(path);
    final uploadTask = ref.put(
      fileBytes,
      firebase.UploadMetadata(
        contentDisposition: getContentDispositionString(cloudFile.name),
        contentType: file.getType().toData(),
        customMetadata: cloudFile.toMetaData().toJson(),
      ),
    );
    return FirebaseJSConverter.uploadTaskFromFirebase(ref, uploadTask);
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
    final path = cloudStoragePfad.lokalerPfadOhneAnfangsslash;
    final Uint8List fileBytes = localFile.getData();
    final ref = firebase
        .app()
        .storage(cloudStoragePfad.bucket.uri.toString())
        .ref(cloudStoragePfad.lokalerPfad);

    final uploadTask = ref.put(
      fileBytes,
      firebase.UploadMetadata(
        contentDisposition: getContentDispositionString(localFile.getName()),
        cacheControl: cacheControl,
        contentType: localFile.getType().toData(),
        customMetadata: {
          'fileID': fileId,
          'fileName': localFile.getName(),
          'path': path,
          'creatorID': creatorId
        },
      ),
    );

    return FirebaseJSConverter.uploadTaskFromFirebase(ref, uploadTask);
  }
}

FileUploader getFileUploaderImplementation() {
  return WebFirebaseFileUploader();
}

class FirebaseJSConverter {
  static UploadTaskEventType uploadTaskEventTypeFromFirebase(
      firebase.TaskState type) {
    switch (type) {
      case firebase.TaskState.ERROR:
        return UploadTaskEventType.error;
      case firebase.TaskState.CANCELED:
        return UploadTaskEventType.canceled;
      case firebase.TaskState.PAUSED:
        return UploadTaskEventType.paused;
      case firebase.TaskState.RUNNING:
        return UploadTaskEventType.running;
      case firebase.TaskState.SUCCESS:
        return UploadTaskEventType.success;
    }
    throw Exception('This shouldnt happen!');
  }

  static UploadTaskSnapshot uploadTaskSnapshotFromFirebase(
      firebase.StorageReference storageReference,
      firebase.UploadTaskSnapshot storageTaskSnapshot) {
    return UploadTaskSnapshot(
      storageMetaData: UploadMetadata(
        customMetadata: storageTaskSnapshot.metadata.customMetadata,
        sizeBytes: storageTaskSnapshot.metadata.size,
      ),
      totalByteCount: storageTaskSnapshot.totalBytes,
      bytesTransferred: storageTaskSnapshot.bytesTransferred,
      getDownloadUrl: () => storageReference.getDownloadURL(),
    );
  }

  static UploadTask uploadTaskFromFirebase(
      firebase.StorageReference storageReference,
      firebase.UploadTask storageUploadTask) {
    return UploadTask(
      onComplete: storageUploadTask.future.then((storageTaskSnapshot) =>
          uploadTaskSnapshotFromFirebase(
              storageReference, storageTaskSnapshot)),
      events: getSnapshotStreamWithSuccessState(
          storageReference, storageUploadTask),
    );
  }

  static UploadTaskEvent uploadTaskEventFromFirebase(
      firebase.StorageReference storageReference,
      firebase.UploadTaskSnapshot storageTaskEvent) {
    return UploadTaskEvent(
      snapshot:
          uploadTaskSnapshotFromFirebase(storageReference, storageTaskEvent),
      type: uploadTaskEventTypeFromFirebase(storageTaskEvent.state),
    );
  }

  static Stream<UploadTaskEvent> getSnapshotStreamWithSuccessState(
      firebase.StorageReference storageReference,
      firebase.UploadTask storageUploadTask) {
    /// Hier wird, falls alle Daten hochgeladen wurden, manuell ein Success-State
    /// ausgegeben, weil Storage das von alleine, auch bei erfolgreichem Upload
    /// im Web nicht macht.
    return storageUploadTask.onStateChanged.map((snap) {
      if (snap.bytesTransferred == snap.totalBytes) {
        return UploadTaskEvent(
          snapshot: uploadTaskSnapshotFromFirebase(storageReference, snap),
          type: UploadTaskEventType.success,
        );
      }
      return uploadTaskEventFromFirebase(storageReference, snap);
    });
  }
}
