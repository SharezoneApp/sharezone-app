// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum _DeleteDialogOptions { all, onlyUser }

enum AttachmentOperation { delete, unlink }

Future<void> deleteHomeworkDialogsEntry(
    BuildContext context, HomeworkDto homework,
    {bool popTwice = true}) async {
  final option = await showColumnActionsAdaptiveDialog<_DeleteDialogOptions>(
    context: context,
    title: "Für alle löschen?",
    messsage:
        "Soll die Hausaufgabe nur für dich oder für den gesamten Kurs gelöscht werden?",
    actions: const [
      AdaptiveDialogAction(
        title: "Nur für mich",
        popResult: _DeleteDialogOptions.onlyUser,
      ),
      AdaptiveDialogAction(
        title: "Für gesamten Kurs",
        popResult: _DeleteDialogOptions.all,
      ),
    ],
  );

  switch (option) {
    case _DeleteDialogOptions.all:
      _deleteHomeworkForAllAndShowDialogIfAttachementsExist(context, homework,
          popTwice: popTwice);
      break;
    case _DeleteDialogOptions.onlyUser:
      _deleteOnlyForCurrentUser(context, homework);
      break;
    case null:
      break;
  }
}

void _deleteOnlyForCurrentUser(BuildContext context, HomeworkDto homework) {
  final api = BlocProvider.of<SharezoneContext>(context).api.homework;
  api.deleteHomeworkOnlyForCurrentUser(homework);
}

void _deleteHomeworkForAllAndShowDialogIfAttachementsExist(
    BuildContext context, HomeworkDto homework,
    {bool popTwice = true}) {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  if (homework.hasAttachments)
    _showAttachmentsDeleteOrRemainDialog(context, homework, popTwice);
  else {
    api.homework.deleteHomework(homework);
    if (popTwice) Navigator.pop(context);
  }
}

void _deleteHomeworkAndAttachments(SharezoneGateway api, HomeworkDto homework) {
  api.homework.deleteHomework(homework, fileSharingGateway: api.fileSharing);
  for (final attachmentID in homework.attachments) {
    _deletingFile(api.fileSharing, homework, attachmentID);
  }
}

void _deletingFile(FileSharingGateway fileSharingGateway, HomeworkDto homework,
    String attachmentID) {
  fileSharingGateway.cloudFilesGateway
      .deleteFile(homework.courseID, attachmentID);
}

Future<void> _showAttachmentsDeleteOrRemainDialog(
    BuildContext context, HomeworkDto homework, bool popTwice) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final option = await showColumnActionsAdaptiveDialog<AttachmentOperation>(
      context: context,
      title: "Anhänge ebenfalls löschen?",
      messsage:
          "Sollen die Anhänge der Hausaufgabe aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?",
      actions: [
        AdaptiveDialogAction(
          title: "Entknüpfen",
          popResult: AttachmentOperation.unlink,
        ),
        AdaptiveDialogAction(
          title: "Löschen",
          popResult: AttachmentOperation.delete,
          isDefaultAction: true,
          isDestructiveAction: true,
          textColor: Theme.of(context).colorScheme.error,
        ),
      ]);

  if (option == AttachmentOperation.delete)
    _deleteHomeworkAndAttachments(api, homework);
  else if (option == AttachmentOperation.unlink)
    api.homework.deleteHomework(homework);

  if (option != null && popTwice) Navigator.pop(context);
}
