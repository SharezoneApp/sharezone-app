// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:crash_analytics/crash_analytics.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_downloader.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/widgets.dart';

class DownloadUnknownFileFormatPage extends StatelessWidget {
  const DownloadUnknownFileFormatPage({
    Key key,
    @required this.actions,
    @required this.name,
    @required this.id,
    @required this.downloadURL,
    @required this.nameStream,
  })  : assert(downloadURL != null),
        super(key: key);

  final List<Widget> actions;
  final String name;
  final String id;
  final String downloadURL;
  final Stream<String> nameStream;

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
    Key key,
    @required this.name,
    @required this.nameStream,
    @required this.downloadURL,
    @required this.id,
  }) : super(key: key);

  final String name;
  final String downloadURL;
  final Stream<String> nameStream;
  final String id;

  @override
  Widget build(BuildContext context) {
    final Widget child = FutureBuilder<LocalFile>(
      future: getFileDownloader().downloadFileFromURL(downloadURL, name, id),
      builder: (context, future) {
        // Finished Downloading
        if (future.hasData) {
          // Für Android ist es besser, wenn die Extension der File lowerCase
          // gemacht wird, damit Android die korrekte App nutzt, um die Datei
          // zu öffnen. Ist die Endung PNG z. B. großgeschrieben, weiß Android
          // nicht, wie es geöffnet werden soll.
          // iOS öffnet jedoch auch die richtige App, wenn die Endung großgeschrieben
          // ist. Jedoch muss der Path zur File case-sensitive, wodurch die Endung
          // nicht bearbeitet werden darf. Deswegen gibt es die Unterscheidung
          // zwischen iOS und Android
          if (PlatformCheck.isIOS) {
            OpenFile.open(future.data.getPath());
          } else {
            OpenFile.open(
                    _getFilePathWithLowerCaseExtension(future.data.getPath()))
                .then((result) => print('open file result: ${result.message}'));
          }

          _closeDialogAfter1500Milliseconds(context);
          return _FinishDialog();
        }

        // Error Dialog
        if (future.hasError) {
          getCrashAnalytics().recordError(future.error, StackTrace.current);
          return _ErrorDialog(error: future.error.toString());
        }

        // Loading
        return _LoadingDialog();
      },
    );

    if (!PlatformCheck.isAndroid) return child;

    return FutureBuilder<AndroidDeviceInformation>(
      future: MobileDeviceInformationRetreiver().androidInfo,
      builder: (context, versionFuture) {
        if (!versionFuture.hasData) return _LoadingDialog();

        const brokenFileTypes = ['docx', 'xlsx', 'pptx'];
        if (PlatformCheck.isAndroid &&
            versionFuture.data.version.sdkInt >= 29 &&
            brokenFileTypes.contains(FileUtils.getExtension(name))) {
          launchURL(downloadURL, context: context);
          _closeDialogAfter1500Milliseconds(context);
          return _FinishDialog();
        }

        return child;
      },
    );
  }

  String _getFilePathWithLowerCaseExtension(String filePath) {
    final indexOfLastPoint = filePath.lastIndexOf(".");
    if (indexOfLastPoint > 0) {
      final lowerCaseExtension = FileUtils.getExtension(filePath);
      return filePath.replaceRange(
          indexOfLastPoint + 1, filePath.length, lowerCaseExtension);
    }
    return filePath;
  }

  void _closeDialogAfter1500Milliseconds(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      Navigator.pop(context);
    });
  }
}

class _FinishDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Dialog(
      leading: Icon(Icons.check_circle, color: Colors.green),
      text: "Datei wird geöffnet...",
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({Key key, @required this.error}) : super(key: key);

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
  const _LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      leading: const AccentColorCircularProgressIndicator(),
      text: "Die Datei wird auf dein Gerät gebeamt...",
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({Key key, this.leading, this.text}) : super(key: key);

  final Widget leading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 8),
            if (leading != null) ...[
              Padding(padding: EdgeInsets.all(16), child: leading),
              const SizedBox(width: 6),
            ],
            Flexible(
                child: Text(
              text,
              style: TextStyle(fontSize: 16),
            )),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }
}
