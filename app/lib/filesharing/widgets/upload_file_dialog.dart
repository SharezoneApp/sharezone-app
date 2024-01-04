// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:filesharing_logic/file_uploader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> showUploadFileDialog({
  required BuildContext context,
  required Future<UploadTask> task,
}) async {
  final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
  showDialog(
      context: context,
      builder: (context) => _UploadFileDialogContent(task: task));
  final uploadTask = await task;
  await uploadTask.onComplete.then((result) {
    if (result.bytesTransferred == result.totalByteCount) {
      analytics.log(NamedAnalyticsEvent(name: "file_add"));
      Navigator.pop(context);
    }
  });
}

class _UploadFileDialogContent extends StatefulWidget {
  const _UploadFileDialogContent({this.task});

  final Future<UploadTask>? task;

  @override
  __UploadFileDialogContentState createState() =>
      __UploadFileDialogContentState();
}

class __UploadFileDialogContentState extends State<_UploadFileDialogContent> {
  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        content: FutureBuilder<UploadTask>(
            future: widget.task, builder: buildDialog),
      );
    }
    return SimpleDialog(
      children: <Widget>[
        FutureBuilder<UploadTask>(future: widget.task, builder: buildDialog),
      ],
    );
  }

  Widget buildDialog(BuildContext context, AsyncSnapshot<UploadTask> future) {
    return FutureBuilder<UploadTask>(
      future: widget.task,
      builder: (context, future) {
        if (!future.hasData) return const _UploadingDialog(percent: 0);
        return StreamBuilder<UploadTaskEvent>(
          stream: future.data!.events,
          builder: (context, snapshot) {
            final event = snapshot.data;
            if (snapshot.hasError) {
              return _UploadingDialogFailure(error: snapshot.error);
            }
            if (event == null) return const _UploadingDialog(percent: 0);

            final percent = event.snapshot.bytesTransferred /
                event.snapshot.totalByteCount *
                100;
            if (event.type == UploadTaskEventType.error) {
              return const _UploadingDialogFailure(error: "Fehler");
            }
            return _UploadingDialog(percent: percent);
          },
        );
      },
    );
  }
}

class _UploadingDialog extends StatelessWidget {
  const _UploadingDialog({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AccentColorCircularProgressIndicator(
              value: percent == 0 ? null : percent / 100),
        ),
        const SizedBox(width: 6),
        Flexible(
            child: Text(
          "Die Datei wird auf den Server gebeamt: ${percent.toStringAsFixed(0)}/100",
          style: const TextStyle(fontSize: 16),
        )),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _UploadingDialogFailure extends StatelessWidget {
  const _UploadingDialogFailure({required this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 8),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Icon(Icons.error_outline),
        ),
        const SizedBox(width: 6),
        Flexible(
            child: Text(
          "Es gab einen Fehler: $error",
          style: const TextStyle(fontSize: 16),
        )),
        const SizedBox(width: 12),
      ],
    );
  }
}
