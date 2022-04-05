// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/files_models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileIcon extends StatelessWidget {
  const FileIcon({Key key, @required this.fileFormat}) : super(key: key);

  final FileFormat fileFormat;

  @override
  Widget build(BuildContext context) {
    switch (fileFormat) {
      case FileFormat.audio:
        return const Icon(Icons.audiotrack, color: Colors.orange);
      case FileFormat.excel:
        return const Icon(Icons.table_chart, color: Colors.green);
      case FileFormat.image:
        return const Icon(Icons.photo, color: Colors.red);
      case FileFormat.pdf:
        return const Icon(FontAwesomeIcons.filePdf, color: Colors.red);
      case FileFormat.text:
        return const Icon(Icons.insert_drive_file, color: Colors.blue);
      case FileFormat.video:
        return const Icon(Icons.movie, color: Colors.red);
      case FileFormat.zip:
        return const Icon(FontAwesomeIcons.box);
      case FileFormat.unknown:
      default:
        return Icon(Icons.insert_drive_file, color: Colors.grey[600]);
    }
  }
}
