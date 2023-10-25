// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:collection/collection.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_picker.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/filesharing/dialog/file_card.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class AttachFile extends StatelessWidget {
  const AttachFile({
    Key? key,
    required this.localFilesStream,
    required this.cloudFilesStream,
    required this.addLocalFileToBlocMethod,
    required this.removeLocalFileFromBlocMethod,
    required this.removeCloudFileFromBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;
  final ValueChanged<LocalFile> removeLocalFileFromBlocMethod;

  final ValueChanged<CloudFile> removeCloudFileFromBlocMethod;

  final Stream<List<CloudFile>> cloudFilesStream;
  final Stream<List<LocalFile>> localFilesStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LocalFile>>(
        stream: localFilesStream,
        builder: (context, localFilesSnapshot) {
          return StreamBuilder<List<CloudFile>>(
              stream: cloudFilesStream,
              builder: (context, cloudFilesSnapshot) {
                if (!localFilesSnapshot.hasData ||
                    !cloudFilesSnapshot.hasData) {
                  return Container();
                }
                return AttachFileBase(
                  onLocalFilesAdded: addLocalFileToBlocMethod,
                  onLocalFileRemoved: removeLocalFileFromBlocMethod,
                  onCloudFileRemoved: removeCloudFileFromBlocMethod,
                  cloudFiles: cloudFilesSnapshot.data!,
                  localFiles: localFilesSnapshot.data!,
                );
              });
        });
  }
}

class AttachFileBase extends StatelessWidget {
  const AttachFileBase({
    Key? key,
    required this.onLocalFilesAdded,
    required this.onLocalFileRemoved,
    required this.onCloudFileRemoved,
    required this.cloudFiles,
    required this.localFiles,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> onLocalFilesAdded;
  final ValueChanged<LocalFile> onLocalFileRemoved;
  final ValueChanged<CloudFile> onCloudFileRemoved;

  final List<CloudFile> cloudFiles;
  final List<LocalFile> localFiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _AddLocalFile(addLocalFileToBlocMethod: onLocalFilesAdded),
        Column(
          children: cloudFiles
              .map((cloudFile) => FileCard(
                  cloudFile: cloudFile,
                  onTap: () => showRemoveFileFromBlocDialog(
                        context: context,
                        removeFileFromBlocMethod: () =>
                            onCloudFileRemoved(cloudFile),
                      ),
                  trailing: FileMoreOptionsWithOnlyRemoveFileFromBloc(
                      key: HwDialogKeys.attachmentOverflowMenuIcon,
                      removeFileFromBlocMethod: () =>
                          onCloudFileRemoved(cloudFile))))
              .toList(),
        ),
        Column(
          children: localFiles
              .map(
                (localFile) => FileCard(
                  localFile: localFile,
                  onTap: () => showRemoveFileFromBlocDialog(
                    context: context,
                    removeFileFromBlocMethod: () =>
                        onLocalFileRemoved(localFile),
                  ),
                  trailing: FileMoreOptionsWithOnlyRemoveFileFromBloc(
                      removeFileFromBlocMethod: () =>
                          onLocalFileRemoved(localFile)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _AddLocalFile extends StatelessWidget {
  const _AddLocalFile({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.attach_file),
      title: const Text("Anhang hinzufügen"),
      onTap: () async {
        if (PlatformCheck.isDesktopOrWeb) {
          final analytics =
              BlocProvider.of<SharezoneContext>(context).analytics;
          final pickedFiles = await FilePicker().pickMultiFile();
          if (pickedFiles != null && pickedFiles.isNotEmpty) {
            final localFiles = pickedFiles.toList();
            addLocalFileToBlocMethod(localFiles);
            analytics.log(NamedAnalyticsEvent(name: "attachment_add"));
          }
        } else {
          await closeKeyboardAndWait(context);
          if (!context.mounted) return;

          final error = await showDialog<String>(
            context: context,
            builder: (context) => AddLocalFileDialog(
                addLocalFileToBlocMethod: addLocalFileToBlocMethod),
          );
          if (!context.mounted) return;

          if (error != null) {
            showSnackSec(
              text: error,
              context: context,
            );
          }
        }
      },
    );
  }
}

class AddLocalFileDialog extends StatelessWidget {
  const AddLocalFileDialog({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0),
      children: <Widget>[
        _PickDocumentTile(addLocalFileToBlocMethod: addLocalFileToBlocMethod),
        _PickPictureTile(addLocalFileToBlocMethod: addLocalFileToBlocMethod),
        _PickVideoTile(addLocalFileToBlocMethod: addLocalFileToBlocMethod),
        _OpenCameraTile(addLocalFileToBlocMethod: addLocalFileToBlocMethod),
      ],
    );
  }
}

class _PickDocumentTile extends StatelessWidget {
  const _PickDocumentTile({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return LongPressDialogTile(
      title: "Dokument",
      iconData: Icons.insert_drive_file,
      onTap: () async {
        Navigator.pop(context);
        final pickedFiles = await FilePicker().pickMultiFile();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          final localFiles = pickedFiles.toList();
          addLocalFileToBlocMethod(localFiles);
          analytics.log(NamedAnalyticsEvent(name: "attachment_document_add"));
          analytics.log(NamedAnalyticsEvent(name: "attachment_add"));
        }
      },
    );
  }
}

class _PickPictureTile extends StatelessWidget {
  const _PickPictureTile({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return LongPressDialogTile(
      title: "Bilder",
      iconData: Icons.photo,
      onTap: () async {
        Navigator.pop(context);
        final pickedFiles = PlatformCheck.isIOS
            ? [await FilePicker().pickFileImage()]
            : await FilePicker().pickMultiFileImage();
        if (pickedFiles != null && pickedFiles.whereNotNull().isNotEmpty) {
          final localFiles = pickedFiles.whereNotNull().toList();
          addLocalFileToBlocMethod(localFiles);
          _logAttachmentViaPicture(analytics);
          _logAttachmentAdd(analytics);
        }
      },
    );
  }

  void _logAttachmentViaPicture(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "attachment_picture_add"));
  }
}

class _PickVideoTile extends StatelessWidget {
  const _PickVideoTile({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return LongPressDialogTile(
      title: "Videos",
      iconData: Icons.videocam,
      onTap: () async {
        Navigator.pop(context);
        final pickedFiles = PlatformCheck.isIOS
            ? [await FilePicker().pickFileVideo()]
            : await FilePicker().pickMultiFileVideo();
        if (pickedFiles != null && pickedFiles.whereNotNull().isNotEmpty) {
          final localFiles = pickedFiles.whereNotNull().toList();
          addLocalFileToBlocMethod(localFiles);
          _logAttachmentViaVideo(analytics);
          _logAttachmentAdd(analytics);
        }
      },
    );
  }

  void _logAttachmentViaVideo(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "attachment_video_add"));
  }
}

class _OpenCameraTile extends StatelessWidget {
  const _OpenCameraTile({
    Key? key,
    required this.addLocalFileToBlocMethod,
  }) : super(key: key);

  final ValueChanged<List<LocalFile>> addLocalFileToBlocMethod;

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

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return LongPressDialogTile(
      title: "Kamera",
      iconData: Icons.photo_camera,
      onTap: () async {
        final hasPermissions = await _checkCameraPermission();
        if (hasPermissions && context.mounted) {
          Navigator.pop(context);
          final image = await FilePicker().pickImageCamera();
          if (image != null) {
            final localFile = image;
            addLocalFileToBlocMethod([localFile]);
            _logAttachmentAddViaCamera(analytics);
            _logAttachmentAdd(analytics);
          }
        } else {
          if (context.mounted) {
            Navigator.pop(
                context, "Die App hat leider keinen Zugang zur Kamera...");
          }
        }
      },
    );
  }

  void _logAttachmentAddViaCamera(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "attachment_camera_add"));
  }
}

void _logAttachmentAdd(Analytics analytics) {
  analytics.log(NamedAnalyticsEvent(name: "attachment_add"));
}
