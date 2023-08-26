// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/file_sharing/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/dialog/file_card.dart';
import 'package:sharezone/filesharing/logic/open_cloud_file.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone/filesharing/widgets/sheet.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class AttachmentStreamList extends StatelessWidget {
  const AttachmentStreamList({
    Key key,
    @required this.cloudFileStream,
    @required this.courseID,
    this.initialAttachmentIDs,
  }) : super(key: key);

  final Stream<List<CloudFile>> cloudFileStream;
  final String courseID;

  /// Wird benötigt, um beim Laden direkt einen Platzhalter für diese Dateien einzurichten.
  final List<String> initialAttachmentIDs;

  @override
  Widget build(BuildContext context) {
    final fileSharingGateway =
        BlocProvider.of<SharezoneContext>(context).api.fileSharing;
    final bloc = FileSharingPageBloc(fileSharingGateway);
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder<List<CloudFile>>(
        stream: cloudFileStream,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: snapshot.hasData
                ? AttachmentList(
                    courseID: courseID,
                    cloudFiles: snapshot.data,
                  )
                : _Placeholder(initialAttachmentIDs: initialAttachmentIDs),
          );
        },
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({Key key, this.initialAttachmentIDs}) : super(key: key);

  final List<String> initialAttachmentIDs;

  @override
  Widget build(BuildContext context) {
    if (initialAttachmentIDs == null || initialAttachmentIDs.isEmpty)
      return Container();
    return Column(
      children: [for (final id in initialAttachmentIDs) emptyFileCard(id)],
    );
  }

  Widget emptyFileCard(String id) {
    return GrayShimmer(
      enabled: true,
      key: ValueKey(id),
      child: ListTile(
        leading: FileIcon(fileFormat: FileFormat.image),
        title: Text("Laden..."),
        trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: null),
      ),
    );
  }
}

class AttachmentList extends StatelessWidget {
  const AttachmentList({
    Key key,
    this.cloudFiles,
    @required this.courseID,
  }) : super(key: key);

  final List<CloudFile> cloudFiles;
  final String courseID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final cloudFile in cloudFiles)
          FileCard(
            key: ValueKey(cloudFile.id),
            cloudFile: cloudFile,
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showCloudFileSheet(
                context: context,
                cloudFile: cloudFile,
                bloc: bloc,
              ),
            ),
            onTap: () => openCloudFilePage(context, cloudFile, courseID),
          )
      ],
    );
  }
}
