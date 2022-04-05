// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filesharing_logic/filesharing_gateways.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';

class FilesharingCloudFilesGateway
    implements CloudFileAccessor, CloudFileOperator {
  final AuthUser user;
  final String uID;
  CollectionReference<Map<String, dynamic>> get filesCollection =>
      _fStore.collection("Files");
  final FirebaseFirestore _fStore;

  FilesharingCloudFilesGateway(
      {@required this.user, @required FirebaseFirestore firestore})
      : uID = user.uid,
        _fStore = firestore;

  @override
  Future<void> deleteFile(String courseID, String fileID) {
    return filesCollection.doc(fileID).delete();
  }

  @override
  Stream<List<CloudFile>> filesStreamAttachment(
      String courseID, String referenceID) {
    return filesCollection
        .where('references', arrayContains: referenceID)
        // Es muss zusätzlich nach der UID gesucht werden, damit die
        // Security-Rules korrekt konfiguriert werden können.
        .where('forUsers.$uID', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnapshot) => CloudFile.fromData(docSnapshot.data()))
            .toList());
  }

  @override
  Stream<List<CloudFile>> filesStreamFolder(String courseID, FolderPath path) {
    return filesCollection
        .where('courseID', isEqualTo: courseID)
        .where('path', isEqualTo: path.toPathString())
        // Es muss zusätzlich nach der UID gesucht werden, damit die
        // Security-Rules korrekt konfiguriert werden können.
        .where('forUsers.$uID', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnapshot) => CloudFile.fromData(docSnapshot.data()))
            .toList());
  }

  @override
  Stream<List<CloudFile>> filesStreamFolderAndSubFolders(
      String courseID, FolderPath path) {
    return filesCollection
        .where('courseID', isEqualTo: courseID)
        .where('path', isGreaterThan: path.toPathString())
        .where('path', isLessThan: '${path.toPathString()}{')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((docSnapshot) => CloudFile.fromData(docSnapshot.data()))
            .toList());
  }

  @override
  Future<void> moveFile(CloudFile file, FolderPath newPath) async {
    final newCloudFile = file.copyWith(path: newPath);
    final ref = filesCollection.doc(file.id);
    ref.set({'path': newCloudFile.path.toString()}, SetOptions(merge: true));
  }

  @override
  Future<void> renameFile(CloudFile file) async {
    DocumentReference ref = filesCollection.doc(file.id);
    ref.set({'name': file.name}, SetOptions(merge: true));
  }

  @override
  Stream<CloudFile> cloudFileStream(String cloudFileID) {
    return filesCollection
        .doc(cloudFileID)
        .snapshots()
        .map((docSnapshot) => CloudFile.fromData(docSnapshot.data()));
  }

  @override
  Stream<String> nameStream(String cloudFileID) =>
      cloudFileStream(cloudFileID).map((file) => file.name);
}
