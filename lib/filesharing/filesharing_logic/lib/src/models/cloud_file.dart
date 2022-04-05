// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:files_basics/files_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'change_activity.dart';
import 'folder_path.dart';
import 'reference_data.dart';

class CloudFile {
  final String id;

  final List<ChangeActivity> changes;

  final List<String> references;
  final Map<String, ReferenceData> referenceData;

  final String creatorID;
  final String creatorName;
  final String courseID;

  final FolderPath path;

  final String name;
  final String downloadURL;
  final String thumbnailURL;
  final DateTime createdOn;
  final int sizeBytes;
  final FileFormat fileFormat;

  /// Aufgrund der Security-Rules müssen die UIs in dem CloudFile-Dokument
  /// stehen. Da für die Anhänge bereits array_contains in der Query
  /// verwendet wird, kann nicht ein zweites array_contains benutzt
  /// werden. Workaround: Die UIDs nicht in der Liste speichern, sondern
  /// in einer Map, wodurch in der Query isEqualTo verwendet werden kann.
  final Map<String, bool> forUsers;

  const CloudFile._({
    @required this.id,
    @required this.changes,
    @required this.references,
    @required this.referenceData,
    @required this.creatorID,
    @required this.creatorName,
    @required this.courseID,
    @required this.path,
    @required this.name,
    @required this.downloadURL,
    @required this.thumbnailURL,
    @required this.createdOn,
    @required this.sizeBytes,
    @required this.fileFormat,
    @required this.forUsers,
  });

  factory CloudFile.create({
    @required String id,
    @required String creatorID,
    @required String creatorName,
    @required String courseID,
    FolderPath path = FolderPath.root,
  }) {
    return CloudFile._(
      id: id,
      changes: [],
      references: [],
      referenceData: {},
      creatorID: creatorID,
      creatorName: creatorName,
      courseID: courseID,
      path: path,
      name: null,
      downloadURL: null,
      thumbnailURL: null,
      createdOn: DateTime.now(),
      sizeBytes: null,
      fileFormat: FileFormat.unknown,
      forUsers: {},
    );
  }

  factory CloudFile.fromData(Map<String, dynamic> data) {
    return CloudFile._(
      id: data['id'],
      changes: decodeList(data['changes'], (it) => ChangeActivity.fromData(it)),
      references: decodeList(data['references'], (it) => it),
      referenceData: decodeMap(data['referenceData'],
          (key, value) => ReferenceData.fromMapData(id: key, data: value)),
      creatorID: data['creatorID'],
      creatorName: data['creatorName'],
      courseID: data['courseID'],
      path: FolderPath.fromPathString(data['path']),
      name: data['name'],
      downloadURL: data['downloadURL'],
      thumbnailURL: data['thumbnailURL'],
      createdOn: ((data['createdOn'] ?? Timestamp.now()) as Timestamp).toDate(),
      sizeBytes: data['sizeBytes'],
      fileFormat: fileTypeEnumFromString(data['fileType']),
      // Users-Map wird absichtlich leer gelassen, da diese nicht verwendet
      // wird und deswegen nicht gespeichert werden muss. Die Users-Map wird nur
      // bei .toJson() verwendet, damit die UID sofort in der Users-Map enthalten ist
      // und somit direkt die Files-Dokumente geladen werden können (ohne auf die CF zu
      // warten).
      forUsers: {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'changes': changes.map((value) => value.toJson()).toList(),
      // 'references': references,
      // 'referencesData':
      //    referenceData.map((key, value) => MapEntry(key, value.toJson())),
      'creatorID': creatorID,
      'creatorName': creatorName,
      'courseID': courseID,
      'path': path?.toPathString() ?? '/',
      'name': name,
      'downloadURL': downloadURL,
      'thumbnailURL': thumbnailURL,
      'createdOn': Timestamp.now(),
      'sizeBytes': sizeBytes,
      'fileType': fileTypeEnumToString(fileFormat),
      'forUsers': forUsers,
    };
  }

  CloudFile copyWith({
    String id,
    List<ChangeActivity> changes,
    List<String> references,
    Map<String, ReferenceData> referenceData,
    String creatorID,
    String creatorName,
    String courseID,
    FolderPath path,
    String name,
    String downloadURL,
    String thumbnailURL,
    DateTime createdOn,
    int sizeBytes,
    FileFormat fileFormat,
    Map<String, bool> forUsers,
  }) {
    return CloudFile._(
      id: id ?? this.id,
      changes: changes ?? this.changes,
      references: references ?? this.references,
      referenceData: referenceData ?? this.referenceData,
      creatorID: creatorID ?? this.creatorID,
      creatorName: creatorName ?? this.creatorName,
      courseID: courseID ?? this.courseID,
      path: path ?? this.path,
      name: name ?? this.name,
      downloadURL: downloadURL ?? this.downloadURL,
      thumbnailURL: thumbnailURL ?? this.thumbnailURL,
      createdOn: createdOn ?? this.createdOn,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileFormat: fileFormat ?? this.fileFormat,
      forUsers: forUsers ?? this.forUsers,
    );
  }

  CloudFileMetaData toMetaData() {
    return CloudFileMetaData(
      fileID: id,
      fileName: name,
      path: path.toPathString(),
      creatorID: creatorID,
    );
  }
}

class CloudFileMetaData {
  String fileID, fileName, path, creatorID;

  CloudFileMetaData(
      {@required this.fileID,
      @required this.fileName,
      @required this.path,
      @required this.creatorID});

  Map<String, String> toJson() {
    return {
      'fileID': fileID,
      'fileName': fileName,
      'path': path,
      'creatorID': creatorID,
    };
  }
}

List<CloudFile> matchRemovedCloudFilesFromTwoList(
    List<CloudFile> biggerList, List<CloudFile> smallerList) {
  List<CloudFile> removedCloudFiles = [];
  biggerList.forEach((biggerListFile) {
    if (!smallerList.contains(biggerListFile)) {
      removedCloudFiles.add(biggerListFile);
    }
  });
  return removedCloudFiles;
}
