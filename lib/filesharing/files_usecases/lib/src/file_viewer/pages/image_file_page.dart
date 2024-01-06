// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:typed_data';

import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import '../../../file_downloader.dart';
import '../widgets/file_page_app_bar.dart';

class ImageFilePage extends StatefulWidget {
  const ImageFilePage({
    super.key,
    this.actions,
    required this.downloadURL,
    required this.name,
    required this.nameStream,
    required this.id,
  });

  static const tag = "image-page";
  final List<Widget>? actions;

  final String downloadURL;
  final String name;
  final Stream<String>? nameStream;
  final String id;

  @override
  State createState() => _ImageFilePageState();
}

class _ImageFilePageState extends State<ImageFilePage> {
  bool showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        appBar: showAppBar
            ? FilePageAppBar(
                name: widget.name,
                actions: widget.actions,
                nameStream: widget.nameStream,
              )
            : null,
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => setState(() => showAppBar = !showAppBar),
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: SingleChildScrollView(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height - (showAppBar ? 80 : 0),
                child: Center(
                  child: PlatformCheck.isWeb
                      ? _buildPhotoViewWeb()
                      : _buildPhotoView(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoView() {
    return FutureBuilder<LocalFile>(
      future: getFileDownloader()!
          .downloadFileFromURL(widget.downloadURL, widget.name, widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AccentColorCircularProgressIndicator();
        }
        return PhotoView(
          minScale: PhotoViewComputedScale.contained,
          maxScale: 10.0,
          loadingBuilder: (context, event) =>
              const AccentColorCircularProgressIndicator(),
          imageProvider: FileImage(snapshot.data!.getFile()),
        );
      },
    );
  }

  Widget _buildPhotoViewWeb() {
    return FutureBuilder<Uint8List>(
        future: getFileSaver()!.downloadAndReturnBytes(widget.downloadURL),
        builder: (context, resultSnapshot) {
          if (resultSnapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            );
          }
          if (!resultSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final result = resultSnapshot.data!;

          return PhotoView(
            minScale: PhotoViewComputedScale.contained,
            maxScale: 10.0,
            loadingBuilder: (context, event) =>
                const AccentColorCircularProgressIndicator(),
            imageProvider: MemoryImage(result),
          );
        });
  }
}
