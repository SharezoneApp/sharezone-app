// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:typed_data';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_downloader.dart';
import 'package:files_usecases/file_saver.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/filesharing/bloc/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/open_cloud_file.dart';
import 'package:sharezone/filesharing/widgets/card_with_icon_and_text.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone/filesharing/widgets/sheet.dart';

class FileGridCard extends StatelessWidget {
  const FileGridCard({
    super.key,
    required this.cloudFile,
    required this.courseId,
  });

  final CloudFile cloudFile;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return CardWithIconAndText(
      height: 256,
      icon: FileIcon(fileFormat: cloudFile.fileFormat),
      text: cloudFile.name,
      onTap: () => openCloudFilePage(context, cloudFile, courseId),
      bottom: Expanded(child: _FileGridCardBottom(cloudFile: cloudFile)),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed:
            () => showCloudFileSheet(
              cloudFile: cloudFile,
              context: context,
              bloc: bloc,
            ),
      ),
    );
  }
}

class _FileGridCardBottom extends StatelessWidget {
  const _FileGridCardBottom({required this.cloudFile});

  final CloudFile cloudFile;

  @override
  Widget build(BuildContext context) {
    if (cloudFile.downloadURL == null) return const SizedBox();

    if (cloudFile.fileFormat != FileFormat.image) {
      return Center(
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(size: 80),
          child: FileIcon(fileFormat: cloudFile.fileFormat),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 4),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child:
            PlatformCheck.isWeb
                ? _ImagePreviewWeb(cloudFile: cloudFile)
                : _ImagePreviewNative(cloudFile: cloudFile),
      ),
    );
  }
}

class _ImagePreviewWeb extends StatelessWidget {
  const _ImagePreviewWeb({required this.cloudFile});

  final CloudFile cloudFile;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getFileSaver()!.downloadAndReturnBytes(cloudFile.downloadURL!),
      builder: (context, resultSnapshot) {
        if (resultSnapshot.hasError) {
          return const Center(
            child: Icon(Icons.error_outline, color: Colors.red),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              resultSnapshot.hasData
                  ? Image.memory(
                    resultSnapshot.data!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: 400,
                    frameBuilder: (
                      context,
                      child,
                      frame,
                      wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $error');
                      return const Center(
                        child: Icon(Icons.error_outline, color: Colors.red),
                      );
                    },
                  )
                  : const SizedBox(),
        );
      },
    );
  }
}

class _ImagePreviewNative extends StatelessWidget {
  const _ImagePreviewNative({required this.cloudFile});

  final CloudFile cloudFile;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalFile>(
      future: getFileDownloader()!.downloadFileFromURL(
        cloudFile.downloadURL!,
        cloudFile.name,
        cloudFile.id!,
      ),
      builder: (context, resultSnapshot) {
        if (resultSnapshot.hasError) {
          debugPrint(resultSnapshot.error.toString());
          return const Center(
            child: Icon(Icons.error_outline, color: Colors.red),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              resultSnapshot.hasData
                  ? Image.file(
                    resultSnapshot.data!.getFile(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: 400,
                    frameBuilder: (
                      context,
                      child,
                      frame,
                      wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $error');
                      return const Center(
                        child: Icon(Icons.error_outline, color: Colors.red),
                      );
                    },
                  )
                  : const SizedBox(),
        );
      },
    );
  }
}
