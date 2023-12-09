// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:crash_analytics/crash_analytics.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_downloader.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class DownloadUnknownFileFormatPage extends StatelessWidget {
  const DownloadUnknownFileFormatPage({
    Key? key,
    required this.actions,
    required this.name,
    required this.id,
    required this.downloadURL,
    required this.nameStream,
  }) : super(key: key);

  final List<Widget>? actions;
  final String? name;
  final String? id;
  final String downloadURL;
  final Stream<String>? nameStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilePageAppBar(
        nameStream: nameStream,
        name: name,
        actions: actions,
      ),
      backgroundColor: Colors.black,
      body: DownloadUnknownFileTypeDialogContent(
        downloadURL: downloadURL,
        id: id,
        name: name,
        nameStream: nameStream,
      ),
    );
  }
}

class DownloadUnknownFileTypeDialogContent extends StatelessWidget {
  const DownloadUnknownFileTypeDialogContent({
    Key? key,
    required this.name,
    required this.nameStream,
    required this.downloadURL,
    required this.id,
  }) : super(key: key);

  final String? name;
  final String? downloadURL;
  final Stream<String>? nameStream;
  final String? id;

  @override
  Widget build(BuildContext context) {
    final Widget child = FutureBuilder<LocalFile>(
      future:
          getFileDownloader()!.downloadFileFromURL(downloadURL!, name!, id!),
      builder: (context, future) {
        // Finished Downloading
        if (future.hasData) {
          OpenFile.open(future.data!.getPath())
              .then((value) => log(value.message));

          _closeDialogAfter1500Milliseconds(context);
          return _FinishDialog();
        }

        // Error Dialog
        if (future.hasError) {
          getCrashAnalytics().recordError(future.error, StackTrace.current);
          return _ErrorDialog(error: future.error.toString());
        }

        // Loading
        return const _LoadingDialog();
      },
    );

    if (!PlatformCheck.isAndroid) return child;

    return FutureBuilder<AndroidDeviceInformation>(
      future: MobileDeviceInformationRetriever().androidInfo,
      builder: (context, versionFuture) {
        if (!versionFuture.hasData) return const _LoadingDialog();

        const brokenFileTypes = ['docx', 'xlsx', 'pptx'];
        if (PlatformCheck.isAndroid &&
            versionFuture.data!.version.sdkInt! >= 29 &&
            brokenFileTypes.contains(FileUtils.getExtension(name!))) {
          launchURL(downloadURL!, context: context);
          _closeDialogAfter1500Milliseconds(context);
          return _FinishDialog();
        }

        return child;
      },
    );
  }

  void _closeDialogAfter1500Milliseconds(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
  }
}

class _FinishDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const _Dialog(
      leading: Icon(Icons.check_circle, color: Colors.green),
      text: "Datei wird geöffnet...",
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      leading: Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      text: "Fehler: $error",
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _Dialog(
      leading: AccentColorCircularProgressIndicator(),
      text: "Die Datei wird auf dein Gerät gebeamt...",
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({Key? key, this.leading, this.text}) : super(key: key);

  final Widget? leading;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 8),
            if (leading != null) ...[
              Padding(padding: const EdgeInsets.all(16), child: leading),
              const SizedBox(width: 6),
            ],
            Flexible(
                child: Text(
              text!,
              style: const TextStyle(fontSize: 16),
            )),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }
}
