// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_picker.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/widgets/material/modal_bottom_sheet_big_icon_button.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'upload_file_dialog.dart';

enum _FABAddOption { newFolder, camera, upload, gallery, video }

class FileSharingPageFAB extends StatelessWidget {
  const FileSharingPageFAB({super.key, this.groupState});

  final FileSharingPageStateGroup? groupState;

  String get courseID => groupState!.groupID;
  FolderPath get path => groupState!.path;

  Future<bool> _checkCameraPermission() async {
    final permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      final cameraRequest = await Permission.camera.request();
      if (cameraRequest == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> onPressed(BuildContext context, FolderPath path) async {
    final option = await showModalBottomSheet<_FABAddOption>(
      context: context,
      builder: (context) => const _FABModalBottomSheetContent(),
    );
    if (!context.mounted) return;

    if (option != null) {
      final api = BlocProvider.of<SharezoneContext>(context).api;
      switch (option) {
        case _FABAddOption.newFolder:
          await Future.delayed(const Duration(milliseconds: 150));
          if (!context.mounted) return;

          showDialog(
            context: context,
            builder:
                (context) => OneTextFieldDialog(
                  title: "Ordner erstellen",
                  hint: "Ordnername",
                  actionName: "Erstellen".toUpperCase(),
                  onTap: (name) async {
                    final creatorName = (await api.user.userStream.first)!.name;
                    final fileSharingData = await api.fileSharing.folderGateway
                        .getFilesharingData(courseID);
                    api.fileSharing.folderGateway.createFolder(
                      courseID,
                      path,
                      Folder.create(
                        id: Folder.generateFolderID(
                          folderName: name!,
                          folderPath: path,
                          fileSharingData: fileSharingData,
                        ),
                        name: name,
                        creatorID: api.uID,
                        creatorName: creatorName,
                        folderType: FolderType.normal,
                      ),
                    );
                    if (!context.mounted) return;

                    Navigator.pop(context);
                  },
                ),
          );
          break;
        case _FABAddOption.gallery:
        case _FABAddOption.upload:
          final tempFiles = <LocalFile>[];
          if (PlatformCheck.isIOS && option == _FABAddOption.gallery) {
            final files = await FilePicker().pickMultiFileImage();
            tempFiles.addAll(files ?? []);
          } else {
            final files = await FilePicker().pickMultiFile();
            tempFiles.addAll(files ?? []);
          }
          if (tempFiles.isNotEmpty) {
            final creatorName = (await api.user.userStream.first)!.name;
            for (final file in tempFiles) {
              final taskAsFuture = api.fileSharing.fileUploader.uploadFile(
                courseID: courseID,
                path: path,
                localFile: file,
                creatorID: api.uID,
                creatorName: creatorName,
              );
              if (!context.mounted) return;

              await showUploadFileDialog(context: context, task: taskAsFuture);
            }
          }
          break;
        case _FABAddOption.camera:
          bool hasPermissions = await _checkCameraPermission();
          if (hasPermissions) {
            final tempImage = await FilePicker().pickImageCamera();
            if (tempImage != null) {
              final creatorName = (await api.user.userStream.first)!.name;
              final taskAsFuture = api.fileSharing.fileUploader.uploadFile(
                courseID: courseID,
                path: path,
                localFile: tempImage,
                creatorID: api.uID,
                creatorName: creatorName,
              );
              if (!context.mounted) return;

              showUploadFileDialog(context: context, task: taskAsFuture);
            }
          } else {
            if (context.mounted) {
              showSnackSec(
                context: context,
                text: "Oh! Die Berechtigung für die Kamera fehlt!",
              );
            }
          }
          break;
        case _FABAddOption.video:
          final video = await FilePicker().pickFileVideo();
          if (video == null) return;

          final creatorName = (await api.user.userStream.first)!.name;
          final taskAsFuture = api.fileSharing.fileUploader.uploadFile(
            courseID: courseID,
            path: path,
            localFile: video,
            creatorID: api.uID,
            creatorName: creatorName,
          );
          if (!context.mounted) return;

          await showUploadFileDialog(context: context, task: taskAsFuture);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPermissionsToUpload = FileSharingPermissionsNoSync.fromContext(
      context,
    ).canUploadFiles(
      courseID: courseID,
      folderPath: path,
      fileSharingData: groupState!.initialFileSharingData,
    );
    if (!hasPermissionsToUpload) return Container();
    return ModalFloatingActionButton(
      tooltip: 'Neu erstellen',
      icon: const Icon(Icons.add),
      onPressed: () => onPressed(context, path),
    );
  }
}

class _FABModalBottomSheetContent extends StatefulWidget {
  const _FABModalBottomSheetContent();

  @override
  __FABModalBottomSheetContentState createState() =>
      __FABModalBottomSheetContentState();
}

class __FABModalBottomSheetContentState
    extends State<_FABModalBottomSheetContent> {
  bool showUploadOptions = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              "Neu erstellen",
              style: TextStyle(
                color:
                    Theme.of(context).isDarkTheme
                        ? Colors.grey[100]
                        : Colors.grey[800],
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 150,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 275),
                  child:
                      showUploadOptions ? getSecondChoice() : getFirstChoice(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSecondChoice() {
    return GestureDetector(
      key: const ValueKey('second-choice'),
      onHorizontalDragEnd: (_) {
        setState(() {
          showUploadOptions = false;
        });
      },
      child: const Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 205),
            child: ModalBottomSheetBigIconButton<_FABAddOption>(
              title: "Bilder",
              iconData: Icons.photo,
              popValue: _FABAddOption.gallery,
              tooltip: "Bilder",
            ),
          ),
          ModalBottomSheetBigIconButton<_FABAddOption>(
            title: "Videos",
            iconData: Icons.movie,
            popValue: _FABAddOption.video,
            tooltip: "Videos",
          ),
          Padding(
            padding: EdgeInsets.only(right: 205),
            child: ModalBottomSheetBigIconButton<_FABAddOption>(
              title: "Dateien",
              iconData: Icons.insert_drive_file,
              popValue: _FABAddOption.upload,
              tooltip: "Dateien",
            ),
          ),
        ],
      ),
    );
  }

  Widget getFirstChoice() {
    return Stack(
      key: const ValueKey('first-choice'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: PlatformCheck.isDesktopOrWeb ? 100 : 205,
          ),
          child: const ModalBottomSheetBigIconButton<_FABAddOption>(
            title: "Ordner",
            iconData: Icons.folder,
            popValue: _FABAddOption.newFolder,
            tooltip: "Neuen Ordner erstellen",
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: PlatformCheck.isDesktopOrWeb ? 100 : 0,
          ),
          child: ModalBottomSheetBigIconButton<_FABAddOption>(
            title: "Hochladen",
            iconData: Icons.file_upload,
            popValue: _FABAddOption.upload,
            tooltip: "Neue Datei hochalden",
            onTap: () {
              if (PlatformCheck.isIOS) {
                setState(() {
                  showUploadOptions = true;
                });
              } else {
                Navigator.pop(context, _FABAddOption.upload);
              }
            },
          ),
        ),
        if (!PlatformCheck.isDesktopOrWeb)
          const Padding(
            padding: EdgeInsets.only(left: 205),
            child: ModalBottomSheetBigIconButton<_FABAddOption>(
              title: "Kamera",
              iconData: Icons.photo_camera,
              popValue: _FABAddOption.camera,
              tooltip: "Kamera öffnen",
            ),
          ),
      ],
    );
  }
}
