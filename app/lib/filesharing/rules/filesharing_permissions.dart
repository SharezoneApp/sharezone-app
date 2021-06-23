import 'package:bloc_provider/bloc_provider.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/util/API.dart';

class FileSharingPermissions {
  final SharezoneGateway api;
  const FileSharingPermissions(this.api);

  Future<MemberRole> _getMemberRole(String courseID) async {
    return (await api.connectionsGateway.get()).courses[courseID].myRole ??
        MemberRole.none;
  }

  factory FileSharingPermissions.fromContext(BuildContext context) {
    return FileSharingPermissions(
        BlocProvider.of<SharezoneContext>(context).api);
  }

  Future<bool> canUploadFiles(
      {@required String courseID, @required FolderPath folderPath}) async {
    final myRole = await _getMemberRole(courseID);
    final bool isCreator = requestPermission(
        role: myRole, permissiontype: PermissionAccessType.creator);
    if (isCreator) return true;

    return false;
  }
}

class FileSharingPermissionsNoSync {
  final SharezoneGateway api;
  const FileSharingPermissionsNoSync(this.api);

  String get _userID => api.uID;

  MemberRole _getMemberRole(String courseID) {
    final connectionsData = api.connectionsGateway.current();
    if (connectionsData != null) {
      final courses = connectionsData.courses;
      if (courses != null) {
        return courses[courseID]?.myRole;
      }
    }
    return MemberRole.none;
  }

  factory FileSharingPermissionsNoSync.fromContext(BuildContext context) {
    return FileSharingPermissionsNoSync(
        BlocProvider.of<SharezoneContext>(context).api);
  }

  bool canUploadFiles({
    @required String courseID,
    @required FolderPath folderPath,
    @required FileSharingData fileSharingData,
  }) {
    final myRole = _getMemberRole(courseID);
    final isCreator = requestPermission(
        role: myRole, permissiontype: PermissionAccessType.creator);
    if (isCreator) return true;

    return false;
  }

  /// Ob ein Nutzer eine Datei Löschen, Umbenennen und Verschieben darf.
  bool canManageCloudFile({@required CloudFile cloudFile}) {
    final isAuthor = cloudFile.creatorID == _userID;
    if (isAuthor) return true;
    final myRole = _getMemberRole(cloudFile.courseID);
    final isAdmin = requestPermission(
        role: myRole, permissiontype: PermissionAccessType.admin);
    return isAdmin;
  }

  bool canCreateDefaultFolder({@required String courseID}) {
    final role = _getMemberRole(courseID);
    return requestPermission(
        role: role, permissiontype: PermissionAccessType.creator);
  }

  /// Ob ein Nutzer einen Ordner Löschen oder Umbenennen darf.
  bool canManageFolder({
    @required String courseID,
    @required Folder folder,
  }) {
    final role = _getMemberRole(courseID);
    final isAdmin = requestPermission(
        role: role, permissiontype: PermissionAccessType.admin);
    if (isAdmin) return true;
    return folder.creatorID == _userID;
  }
}
