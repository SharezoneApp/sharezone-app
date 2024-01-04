// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/bloc/file_page_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FilePage extends StatefulWidget {
  static const tag = "file-page";

  const FilePage({
    super.key,
    required this.fileType,
    this.actions,
    required this.name,
    required this.nameStream,
    required this.downloadURL,
    required this.id,
  }) : assert(!(fileType == FileFormat.pdf ||
            fileType == FileFormat.image ||
            fileType == FileFormat.video));

  final FileFormat fileType;
  final List<Widget>? actions;

  final String name;
  final Stream<String>? nameStream;
  final String downloadURL;
  final String id;

  @override
  State createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  _FilePageState();

  late FilePageBloc filePageBloc;

  FileFormat get fileFormat => widget.fileType;
  String get name => widget.name;

  @override
  void initState() {
    super.initState();
    filePageBloc = FilePageBloc(
      downloadURL: widget.downloadURL,
      id: widget.id,
      name: widget.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalFile>(
      stream: filePageBloc.localFile,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return _LoadingPage(
            name: name,
            nameStream: widget.nameStream,
          );
        }
        if (snapshot.hasError) {
          return _EmptyPage(
            name: name,
            nameStream: widget.nameStream,
            error: snapshot.error,
          );
        }
        final localFile = snapshot.data;
        if (fileFormat == FileFormat.image) {
          return ImageFilePage(
            name: name,
            nameStream: widget.nameStream,
            downloadURL: widget.downloadURL,
            actions: widget.actions,
            id: widget.id,
          );
        }
        if (fileFormat == FileFormat.pdf) {
          return PdfFilePage(
            name: name,
            localFile: localFile!,
            actions: widget.actions,
            nameStream: widget.nameStream,
          );
        }
        return _EmptyPage(
          name: name,
          nameStream: widget.nameStream,
        );
      },
    );
  }
}

class _LoadingPage extends StatefulWidget {
  const _LoadingPage({
    required this.name,
    required this.nameStream,
  });

  final String name;
  final Stream<String>? nameStream;

  @override
  State createState() => _LoadingPageState();
}

class _LoadingPageState extends State<_LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        appBar:
            FilePageAppBar(name: widget.name, nameStream: widget.nameStream),
        body: const Center(child: AccentColorCircularProgressIndicator()),
      ),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  const _EmptyPage({
    required this.name,
    required this.nameStream,
    this.error,
  });

  final String name;
  final Stream<String>? nameStream;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilePageAppBar(name: name, nameStream: nameStream),
      body: Center(
        child: ListTile(
          leading: const Icon(Icons.warning),
          title: const Text("Anzeigefehler"),
          subtitle: error != null ? Text('$error') : null,
        ),
      ),
    );
  }
}
