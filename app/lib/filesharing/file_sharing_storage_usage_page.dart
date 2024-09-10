import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'file_sharing_view_home.dart';
import 'widgets/card_with_icon_and_text.dart';
import 'widgets/cloud_file_icon.dart';

class FileSharingStorageUsagePage extends StatelessWidget {
  const FileSharingStorageUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speicherplatz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MaxWidthConstraintBox(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const FileStorageUsageIndicator(
                  usedStorage: KiloByteSize(gigabytes: 9),
                  totalStorage: KiloByteSize(gigabytes: 10),
                  plusStorage: KiloByteSize(gigabytes: 30),
                ),
                const SizedBox(height: 16),
                CustomCard(
                  borderColor: Colors.blueAccent,
                  child: ListTile(
                    title: Text(
                      'Jetzt auf 30 GB upgraden!',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: SharezonePlusChip(),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Deine hochgeladenen Dateien',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sortiert nach Größe',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                const _File(
                  fileFormat: FileFormat.video,
                  fileName: 'Experiment gefilmt.mp4',
                  fileSize: '8,23 GB',
                ),
                const _File(
                  fileFormat: FileFormat.image,
                  fileName: 'Ergebnisse.jpg',
                  fileSize: '3,7 MB',
                ),
                const _File(
                  fileFormat: FileFormat.pdf,
                  fileName: 'Aufgabe gelöst.pdf',
                  fileSize: '2,4 MB',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _File extends StatelessWidget {
  const _File({
    required this.fileFormat,
    required this.fileName,
    required this.fileSize,
    super.key,
  });

  final FileFormat fileFormat;
  final String fileName;
  final String fileSize;

  @override
  Widget build(BuildContext context) {
    return CardWithIconAndText(
      icon: FileIcon(fileFormat: fileFormat),
      text: fileName,
      onTap: () {},
      trailing: Row(
        children: [
          Text(fileSize),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
