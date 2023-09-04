// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/file_uploader.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'implementation/firebase_file_uploader_impl.dart';

class FirebaseFileUploader {
  final FirebaseFirestore _firestore;

  FirebaseFileUploader({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FirebaseFileUploaderImplementation get implementation =>
      FirebaseFileUploaderImplementation(firestore: _firestore);

  Future<UploadTask> uploadFile({
    required LocalFile localFile,
    required String courseID,
    required String creatorID,
    required String creatorName,
    FolderPath path = FolderPath.root,
  }) async {
    return implementation.uploadFile(
      localFile: localFile,
      courseID: courseID,
      path: path,
      creatorID: creatorID,
      creatorName: creatorName,
    );
  }
}
