import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/bloc/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/open_cloud_file.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone/filesharing/widgets/sheet.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FileListCard extends StatelessWidget {
  const FileListCard({
    super.key,
    required this.file,
    required this.courseID,
    required this.bloc,
  });

  final CloudFile file;
  final String courseID;
  final FileSharingPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () => openCloudFilePage(context, file, courseID),
      child: ListTile(
        leading: FileIcon(fileFormat: file.fileFormat),
        mouseCursor: SystemMouseCursors.click,
        title: Text(file.name),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed:
              () => showCloudFileSheet(
                cloudFile: file,
                context: context,
                bloc: bloc,
              ),
        ),
      ),
    );
  }
}
