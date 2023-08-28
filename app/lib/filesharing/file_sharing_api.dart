// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:sharezone/filesharing/gateways/filesharing_cloud_files_gateway.dart';
import 'package:sharezone/filesharing/gateways/filesharing_folder_gateway.dart';
import 'package:sharezone/filesharing/logic/firebase_file_uploader/firebase_file_uploader.dart';
import 'package:sharezone_common/references.dart';

class FileSharingGateway {
  final AuthUser user;
  final String uID;
  final FirebaseFirestore _fStore;
  CollectionReference<Map<String, dynamic>> get fileSharingCollection =>
      _fStore.collection("FileSharing");
  CollectionReference<Map<String, dynamic>> get filesCollection =>
      _fStore.collection("Files");

  final FirebaseFileUploader fileUploader;

  FileSharingGateway({
    required this.user,
    required References references,
  })  : uID = user.uid,
        _fStore = references.firestore,
        fileUploader = FirebaseFileUploader(firestore: references.firestore),
        cloudFilesGateway = FilesharingCloudFilesGateway(
            user: user, firestore: references.firestore),
        folderGateway = FilesharingFolderGateway(
            user: user, firestore: references.firestore);

  final FilesharingCloudFilesGateway cloudFilesGateway;
  final FilesharingFolderGateway folderGateway;

  Stream<List<FileSharingData>> courseFoldersStream() {
    return fileSharingCollection
        .where("users", arrayContains: uID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnap) =>
                FileSharingData.fromData(id: docSnap.id, data: docSnap.data()))
            .toList());
  }

  Future<List<String>> uploadAttachments(
    List<LocalFile>? localFiles,
    String courseID,
    String authorID,
    String authorName,
  ) async {
    final attachments = <String>[];
    final hasAttachments = localFiles != null && localFiles.isNotEmpty;
    if (hasAttachments) {
      for (final localFile in localFiles) {
        final uploadTask = await fileUploader.uploadFile(
          courseID: courseID,
          creatorID: authorID,
          creatorName: authorName,
          localFile: localFile,
          path: FolderPath.attachments,
        );

        final snapshot = await uploadTask.onComplete;
        final fileID =
            snapshot.storageMetaData.customMetadata!['fileID'] as String;
        attachments.add(fileID);
      }
    }
    return attachments;
  }

  Future<void> addReferenceData(String fileID, ReferenceData referenceData) {
    return filesCollection.doc(fileID).set({
      'references': [referenceData.id],
      'referencesData': {referenceData.id: referenceData.toJson()},
    }, SetOptions(merge: true));
  }

  Future<void> removeReferenceData(String fileID, ReferenceData referenceData) {
    return filesCollection.doc(fileID).set({
      'references': FieldValue.arrayRemove([referenceData.id]),
      'referencesData': {referenceData.id: FieldValue.delete()},
    }, SetOptions(merge: true));
  }
}
