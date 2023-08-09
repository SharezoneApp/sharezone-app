// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/random_string.dart';

class Folder {
  final String id;
  final String? name;

  final String? creatorName;
  final String? creatorID;

  final Map<String, Folder> folders;
  final FolderType? folderType;

  const Folder._({
    required this.id,
    required this.name,
    required this.folders,
    required this.creatorID,
    required this.creatorName,
    required this.folderType,
  });

  factory Folder.create({
    required String id,
    required String name,
    required String creatorID,
    required String creatorName,
    required FolderType folderType,
  }) {
    return Folder._(
      id: id,
      name: name,
      folders: {},
      creatorID: creatorID,
      creatorName: creatorName,
      folderType: folderType,
    );
  }

  factory Folder.fromData(
      {required String id, required Map<String, dynamic> data}) {
    Map<String, Folder>? mFolders;
    try {
      mFolders = decodeMap(data['folders'],
          (key, value) => Folder.fromData(id: key, data: value));
    } catch (e) {
      log("folders error: $id", error: e);
    }
    return Folder._(
      id: id,
      name: data['name'],
      folders: mFolders ?? {},
      creatorID: data['creatorID'],
      creatorName: data['creatorName'] == ""
          ? 'Automatisch erstellt'
          : data['creatorName'],
      folderType: data['folderType'] != null
          ? folderTypeFromString(data['folderType'])
          : FolderType.normal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'folders': folders.map((key, value) => MapEntry(key, value.toJson())),
      'folderType': folderTypeToString(folderType),
      'creatorID': creatorID,
      'creatorName': creatorName,
    };
  }

  Folder copyWith({
    String? name,
    Map<String, Folder>? folders,
    String? creatorID,
    String? creatorName,
    FolderType? folderType,
  }) {
    return Folder._(
      id: id,
      name: name ?? this.name,
      folders: folders ?? this.folders,
      creatorID: creatorID ?? this.creatorID,
      creatorName: creatorName ?? this.creatorName,
      folderType: folderType ?? this.folderType,
    );
  }

  bool isDeletable(FolderPath path) {
    if (path == FolderPath.root && id == 'attachment') {
      return false;
    } else {
      return true;
    }
  }

  static String generateFolderID(
      {FolderPath? folderPath,
      required String folderName,
      required FileSharingData fileSharingData,
      int attempt = 0}) {
    if (attempt >= 10 || attempt < 0) {
      throw Exception('Too Many Attempts to generate random ID!');
    }
    List<Folder> folders =
        fileSharingData.getFolders(folderPath)!.values.toList();
    String nameID = folderName.toLowerCase() +
        (attempt == 0 ? "" : ("(${attempt.toString()})"));
    nameID = nameID.replaceAll(RegExp("[^A-Za-z0-9-_()]"), "");
    if (nameID == "") nameID = randomIDString(6).toLowerCase();
    if (folders.where((it) => it.id == nameID).isNotEmpty) {
      return generateFolderID(
          fileSharingData: fileSharingData,
          folderName: folderName,
          folderPath: folderPath,
          attempt: attempt++);
    } else {
      return nameID;
    }
  }
}
