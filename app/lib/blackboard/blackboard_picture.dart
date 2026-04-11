// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';

const List<String> localPictures = [
  "assets/wallpaper/blackboard/make-photo.png",
  "assets/wallpaper/blackboard/upload.png",
  "assets/wallpaper/blackboard/sport.png",
  "assets/wallpaper/blackboard/students.png",
  "assets/wallpaper/blackboard/meeting.png",
  "assets/wallpaper/blackboard/soccer.png",
  "assets/wallpaper/blackboard/track.png",
  "assets/wallpaper/blackboard/theater.png",
  "assets/wallpaper/blackboard/ice-hockey.png",
  "assets/wallpaper/blackboard/museum.png",
  "assets/wallpaper/blackboard/climbing.png",
];

class BlackboardDialogChoosePicture extends StatelessWidget {
  static const tag = "blackboard-dialog-choose-picture";

  const BlackboardDialogChoosePicture({super.key, this.courseId});

  final String? courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Titelbild auswählen")),
      body: SafeArea(
        child: MaxWidthConstraintBox(
          child: _PictureGrid(courseId: courseId),
        ),
      ),
    );
  }
}

class _PictureGrid extends StatelessWidget {
  const _PictureGrid({required this.courseId});

  final String? courseId;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.count(
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      childAspectRatio: (orientation == Orientation.portrait) ? 1.15 : 1.3,
      children:
          localPictures
              .map(
                (String path) =>
                    _PictureBox(path: path, courseId: courseId),
              )
              .toList(),
    );
  }
}

class _PictureBox extends StatelessWidget {
  const _PictureBox({required this.path, required this.courseId});

  final String path;
  final String? courseId;

  Future<void> _showPlusInfoDialog(BuildContext context) async {
    await showSharezonePlusFeatureInfoDialog(
      context: context,
      navigateToPlusPage: () => navigateToSharezonePlusPage(context),
      title: Text(context.l10n.blackboardTitleImagePlusDialogTitle),
      description: Text(context.l10n.blackboardTitleImagePlusDialogDescription),
    );
  }

  Future<void> _showUploadFailed(BuildContext context) async {
    showSnackSec(
      text: context.l10n.blackboardTitleImageUploadFailed,
      context: context,
    );
  }

  Future<void> _showUploadDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Row(
              children: [
                const AccentColorCircularProgressIndicator(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(context.l10n.blackboardTitleImageUploading),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _handleOwnPhotoTap(
    BuildContext context, {
    required bool useCamera,
  }) async {
    final subscriptionService = context.read<SubscriptionService>();
    final hasPlus = subscriptionService.hasFeatureUnlocked(
      SharezonePlusFeature.infoSheetTitleImageUpload,
    );
    if (!hasPlus) {
      await _showPlusInfoDialog(context);
      return;
    }

    if (courseId == null || courseId!.isEmpty) {
      showSnackSec(
        text: context.l10n.blackboardTitleImageSelectCourseFirst,
        context: context,
      );
      return;
    }

    final LocalFile? pickedFile =
        useCamera
            ? await FilePicker().pickImageCamera()
            : await FilePicker().pickFileImage();

    if (pickedFile == null) return;
    if (!context.mounted) return;

    final api = BlocProvider.of<SharezoneContext>(context).api;
    final authorName = (await api.user.userStream.first)?.name ?? "-";
    final authorID = api.user.authUser!.uid;
    if (!context.mounted) return;

    _showUploadDialog(context);

    try {
      final uploadTask = await api.fileSharing.fileUploader.uploadFile(
        courseID: courseId!,
        creatorID: authorID,
        creatorName: authorName,
        localFile: pickedFile,
        path: FolderPath.attachments,
      );
      final snapshot = await uploadTask.onComplete;
      final downloadUrl = (await snapshot.getDownloadUrl()).toString();
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context, downloadUrl);
    } catch (error) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await _showUploadFailed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 3;
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    return InkWell(
      onTap: () {
        if (path != "assets/wallpaper/blackboard/make-photo.png" &&
            path != "assets/wallpaper/blackboard/upload.png") {
          analytics.log(
            NamedAnalyticsEvent(name: "blackboard_upload_preset_photo"),
          );
          Navigator.pop(context, path);
        } else {
          analytics.log(
            NamedAnalyticsEvent(name: "blackboard_upload_own_photo"),
          );
          _handleOwnPhotoTap(
            context,
            useCamera: path == "assets/wallpaper/blackboard/make-photo.png",
          );
        }
      },
      child: Image.asset(path, height: size, width: size, fit: BoxFit.cover),
    );
  }
}

class BlackboardDialogChoosePictureArgs {
  const BlackboardDialogChoosePictureArgs({required this.courseId});

  final String? courseId;
}
