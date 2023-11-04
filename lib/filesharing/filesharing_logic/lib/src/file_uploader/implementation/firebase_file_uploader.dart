// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

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

class FirebaseFileUploader extends FileUploader {
  /// Uploads a [LocalFile] to Firebase Storage.
  ///
  /// Tries to use the Dart IO file if possible. If not, the file is uploaded
  /// via data (Uint8List).
  fb.UploadTask _uploadToFirebase({
    required fb.Reference reference,
    required LocalFile file,
    fb.SettableMetadata? metadata,
  }) {
    // Defines if the file is available as Dart IO file. Normally this is the
    // case except for files using the web app.
    final hasIOFile = file.getFile() != null;

    if (hasIOFile) {
      // We prefer to upload the file as a Dart IO file if possible.
      //
      // Even though the Firebase Storage plugin supports uploading files via
      // data (Uint8List), we try to avoid this because using the Dart IO is
      // more stable and and doesn't require to load the whole file into memory
      // (can easily cause UI freezes).
      return reference.putFile(file.getFile(), metadata);
    }

    return reference.putData(file.getData(), metadata);
  }

  @override
  Future<UploadTask> uploadFile(
      {required CloudFile cloudFile, required LocalFile file}) async {
    final fileType = FileUtils.getFileFormatFromMimeType(file.getType()!);
    final storageReference = fb.FirebaseStorage.instance
        .ref()
        .child("files")
        .child(cloudFile.courseID!)
        .child(cloudFile.id!);

    if (fileType == FileFormat.image) {
      try {
        final imageCompressor = getImageCompressor();
        final compressedFile = await imageCompressor.compressImage(file);
        if (compressedFile != null) {
          file = compressedFile;
        }
      } catch (e) {
        log("Couldn't compress image: $e", error: e);
      }
    }

    final metadata = fb.SettableMetadata(
      contentDisposition: getContentDispositionString(cloudFile.name),
      contentType: file.getType()!.toData(),
      // TODO: Add private attribute here?
      customMetadata: Map.from(cloudFile.toMetaData().toJson()),
    );

    final uploadTask = _uploadToFirebase(
      reference: storageReference,
      file: file,
      metadata: metadata,
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
      fb.TaskSnapshot taskSnapshot) {
    return UploadTaskSnapshot(
      storageMetaData: UploadMetadata(
        customMetadata: taskSnapshot.metadata?.customMetadata,
        sizeBytes: taskSnapshot.metadata?.size,
      ),
      totalByteCount: taskSnapshot.totalBytes,
      bytesTransferred: taskSnapshot.bytesTransferred,
      getDownloadUrl: () => taskSnapshot.ref.getDownloadURL(),
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
  }

  @override
  Future<UploadTask> uploadFileToStorage(
      CloudStoragePfad cloudStoragePfad, String creatorId, LocalFile localFile,
      {String? cacheControl}) async {
    if (!cloudStoragePfad.istDateiPfad) {
      throw ArgumentError.value(
          cloudStoragePfad, 'cloudStoragePfad', 'muss ein Dateipfad sein.');
    }
    final fileId = cloudStoragePfad.uri.pathSegments.last;
    final fileType = FileUtils.getFileFormatFromMimeType(localFile.getType()!);
    final storage =
        fb.FirebaseStorage.instanceFor(bucket: cloudStoragePfad.bucket.name);
    final storageReference = storage.ref().child(cloudStoragePfad.lokalerPfad);

    /// Bei der Kompression wird der Dateiname verändert, wir wollen aber den
    /// originalen benutzen,
    final originalerName = localFile.getName();

    if (fileType == FileFormat.image) {
      try {
        final imageCompressor = getImageCompressor();
        final compressedFile = await imageCompressor.compressImage(localFile);
        if (compressedFile != null) {
          localFile = compressedFile;
        }
      } catch (e) {
        log("Couldn't compress image: $e", error: e);
      }
    }

    final metadata = fb.SettableMetadata(
      contentDisposition: getContentDispositionString(originalerName),
      contentType: localFile.getType()!.toData(),
      cacheControl: cacheControl,
      customMetadata: {
        'fileID': fileId,
        'fileName': originalerName,
        'creatorID': creatorId
      },
    );

    final uploadTask = _uploadToFirebase(
      reference: storageReference,
      file: localFile,
      metadata: metadata,
    );

    return _uploadTaskFromFirebase(uploadTask);
  }
}

FileUploader getFileUploaderImplementation() {
  return FirebaseFileUploader();
}
