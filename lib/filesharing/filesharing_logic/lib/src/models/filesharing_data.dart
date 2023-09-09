// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:sharezone_common/helper_functions.dart';
import 'filesharing_type.dart';
import 'folder.dart';
import 'folder_path.dart';

class FileSharingData {
  final String courseID;
  final String? courseName;
  final FileSharingType type;
  final Map<String, Folder> folders;
  final List<String?> users;

  const FileSharingData._({
    required this.courseID,
    required this.courseName,
    required this.folders,
    required this.users,
    required this.type,
  });

  factory FileSharingData.create(
      {required String courseID,
      required String courseName,
      required List<String> users}) {
    return FileSharingData._(
      courseID: courseID,
      courseName: courseName,
      folders: {},
      users: users,
      type: FileSharingType.course,
    );
  }

  factory FileSharingData.fromData(
      {required String id, required Map<String, dynamic> data}) {
    Map<String, Folder>? mFolders;
    try {
      mFolders = decodeMap(data['folders'],
          (key, value) => Folder.fromData(id: key, data: value));
    } catch (e, s) {
      log("filesharingdata folders error: $id", error: e, stackTrace: s);
    }
    return FileSharingData._(
        courseID: id,
        courseName: data['courseName'],
        folders: mFolders ?? {},
        users: decodeList(data['users'], (it) => it),
        type: fileSharingTypeEnumFromString(data['type'] ?? 'course'));
  }

  FileSharingData copyWith({
    String? courseID,
    String? courseName,
    Map<String, Folder>? folders,
    List<String>? users,
    FileSharingType? type,
  }) {
    return FileSharingData._(
      courseID: courseID ?? this.courseID,
      courseName: courseName ?? this.courseName,
      folders: folders ?? this.folders,
      users: users ?? this.users,
      type: type ?? this.type,
    );
  }

  Folder? getFolder(FolderPath folderPath) {
    if (folderPath == FolderPath.root) return null;
    final folderIDList = folderPath.getFolderIDs();
    if (folderIDList.length > 1) {
      Folder? lastFolder;
      for (String mFolderID in folderIDList) {
        if (mFolderID == "") {
          lastFolder = null;
        } else {
          if (lastFolder == null) {
            lastFolder = folders[mFolderID];
          } else {
            lastFolder = lastFolder.folders[mFolderID];
          }
        }
      }
      return lastFolder;
    } else {
      return null;
    }
  }

  Map<String, Folder>? getFolders(FolderPath? folderPath) {
    if (folderPath == FolderPath.root) return folders;
    final folderIDList = folderPath!.getFolderIDs();
    if (folderIDList.length > 1) {
      Folder? lastFolder;
      for (String mFolderID in folderIDList) {
        if (mFolderID == "") {
          lastFolder = null;
        } else {
          if (lastFolder == null) {
            lastFolder = folders[mFolderID];
          } else {
            lastFolder = lastFolder.folders[mFolderID];
          }
        }
      }
      return lastFolder?.folders;
    } else {
      return folders;
    }
  }
}
