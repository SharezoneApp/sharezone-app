// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blackboard/blackboard_view.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/widgets/homework/delete_homework.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'details/blackboard_details.dart';

Future<void> showDeleteBlackboardItemDialog(
    BuildContext context, BlackboardView view,
    {bool popTwice = true}) async {
  final confirmed = await _showConfirmDeletingDialog(context);
  if (confirmed) {
    if (view.hasAttachments) {
      _showAttachmentsDeleteOrRemainDialog(context, view, popTwice: popTwice);
    } else {
      final blackboardAPI =
          BlocProvider.of<SharezoneContext>(context).api.blackboard;
      blackboardAPI.deleteBlackboardItemWithoutAttachments(view.id);
      if (popTwice) Navigator.pop(context, BlackboardPopOption.deleted);
    }
  }
}

Future<bool> _showConfirmDeletingDialog(BuildContext context) async {
  return showLeftRightAdaptiveDialog<bool>(
    context: context,
    title: "Eintrag löschen?",
    defaultValue: false,
    content: const Text(
        "Möchtest du wirklich diesen Eintrag für den kompletten Kurs löschen?"),
    left: AdaptiveDialogAction.cancle,
    right: AdaptiveDialogAction.delete,
  );
}

Future<void> _showAttachmentsDeleteOrRemainDialog(
    BuildContext context, BlackboardView view,
    {bool popTwice = true}) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;

  final attachmentsRemainOrDelete =
      await showColumnActionsAdaptiveDialog<AttachmentOperation>(
    context: context,
    title: "Anhänge ebenfalls löschen?",
    messsage:
        "Sollen die Anhänge des Eintrags aus der Dateiablage gelöscht oder die Verknüpfung zwischen beiden aufgehoben werden?",
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
    ],
  );

  if (attachmentsRemainOrDelete != null) {
    api.blackboard.deleteBlackboardItemWithAttachments(
      id: view.id,
      courseID: view.courseID,
      attachmentIDs: view.attachmentIDs,
      fileSharingGateway: api.fileSharing,
      attachmentsRemainOrDelete: attachmentsRemainOrDelete,
    );
    if (popTwice) Navigator.pop(context, BlackboardPopOption.deleted);
  }
}
