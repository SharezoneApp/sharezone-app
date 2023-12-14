// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import '../widgets/file_page_app_bar.dart';

class PdfFilePage extends StatelessWidget {
  const PdfFilePage({
    Key? key,
    required this.localFile,
    this.actions,
    required this.name,
    this.nameStream,
  }) : super(key: key);

  final String name;
  final Stream<String>? nameStream;
  final List<Widget>? actions;
  final LocalFile localFile;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        brightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: FilePageAppBar(
          name: name,
          actions: actions,
          nameStream: nameStream,
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<bool>(
          future: isDeviceSupportedByPdfPlguin(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return PdfView(
                  pageSnapping: false,
                  controller:
                      PdfController(document: getPdfDocument(localFile)),
                  scrollDirection: Axis.vertical,
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    errorBuilder: (context, exception) {
                      return const Center(
                        child: Text(
                          'PDF Rendering does not '
                          'support on the system of this version',
                        ),
                      );
                    },
                    documentLoaderBuilder: (context) => const Center(
                      child: AccentColorCircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                OpenFile.open(localFile.getPath());
                return Container();
              }
            }

            if (snapshot.hasError) {
              // Catch
              return const Center(
                child: Text(
                  'PDF Rendering does not '
                  'support on the system of this version',
                ),
              );
            }

            return const Center(child: AccentColorCircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // Das PDF-Plugin ist nur für Geräte ab Android 5 und iOS 11 verfügbar. Deswegen
  // wird bei älteren Geräten einfach die Datei geöffnet.
  Future<bool> isDeviceSupportedByPdfPlguin() async {
    if (PlatformCheck.isAndroid) {
      final android = await MobileDeviceInformationRetriever().androidInfo;
      return android.version.sdkInt! >= 21;
    } else if (PlatformCheck.isIOS) {
      final ios = await MobileDeviceInformationRetriever().iosInfo;
      final result = ios.systemVersion!.compareTo('11.0.0');
      return result != -1;
    }
    return true;
  }
}

Future<PdfDocument> getPdfDocument(LocalFile localFile) {
  if (PlatformCheck.isMobile) {
    return PdfDocument.openFile(localFile.getPath()!);
  } else {
    return PdfDocument.openData(localFile.getData());
  }
}
