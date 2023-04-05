// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'filesharing_data.dart';

const maximumNestedFolderLevel = 8;

class FolderPath {
  final String _pathString;

  const FolderPath.fromPathString(this._pathString);

  static const FolderPath root = FolderPath.fromPathString('/');
  static const FolderPath attachments =
      FolderPath.fromPathString('/attachment');
  FolderPath getParentPath() {
    final lastFolderLength = _pathString.split("/").last.length;
    final newPath =
        _pathString.substring(0, _pathString.length - (lastFolderLength + 1));
    if (newPath == "") return FolderPath.root;
    return FolderPath.fromPathString(newPath);
  }

  FolderPath getChildPath(String folderID) {
    if (folderID == null || folderID == '') {
      throw ArgumentError("FolderID is not allowed to be null!");
    }
    if (_pathString == "/") {
      return FolderPath.fromPathString(_pathString + folderID);
    }
    return FolderPath.fromPathString("$_pathString/$folderID");
  }

  List<FolderPath> getPathsHierachy() {
    final pathsHierachy = [this];
    var topPath = this;
    while (topPath != FolderPath.root) {
      topPath = topPath.getParentPath();
      pathsHierachy.insert(0, topPath);
    }
    return pathsHierachy;
  }

  // Gibt eine Liste mit den Id's dieses Paths zurück
  List<String> getFolderIDs() {
    return _pathString.split("/");
  }

  /// Der PathString, welcher so gespeichert wird, zum Beispiel '/' oder '/aufgaben/efunktionen'
  String toPathString() {
    return _pathString;
  }

  int getFolderLevel() {
    if (this == FolderPath.root) return 0;
    final folderIDs = getFolderIDs();
    return folderIDs.length - 1;
  }

  /// Die Position im Dokument der [FileSharingData], damit man die Daten im Dokument abgreifen kann.
  String toPathDocumentPosition() {
    String fullPosition = 'folders';
    List<String> subFolders = _pathString.split("/");
    for (String mFolderID in subFolders) {
      if (mFolderID == "") {
      } else {
        fullPosition += ".$mFolderID.folders";
      }
    }
    return fullPosition;
  }

  Map<String, dynamic> getPathDocumentMap(Map<String, dynamic> value) {
    if (this == FolderPath.root) return {'folders': value};
    final folderIDs = getFolderIDs();
    Map<String, dynamic> reversedMap;
    for (String mFolderID in folderIDs.reversed) {
      if (mFolderID == "") {
        reversedMap = {'folders': reversedMap ?? value};
      } else {
        reversedMap = {
          mFolderID: {'folders': reversedMap ?? value}
        };
      }
    }
    return reversedMap;
  }

  Map<String, dynamic> getFolderDocumentMap(String folderID, dynamic value) {
    return getPathDocumentMap({folderID: value});
  }

  @override
  String toString() {
    return toPathString();
  }

  @override
  bool operator ==(other) {
    return other is FolderPath && other._pathString == _pathString;
  }

  @override
  int get hashCode => _pathString.hashCode;
}
