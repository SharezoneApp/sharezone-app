import 'package:bloc_provider/bloc_provider.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/filesharing/logic/move_file_bloc.dart';
import 'package:sharezone/filesharing/widgets/move_file_page_header.dart';
import 'package:sharezone_utils/streams.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/wrappable_list.dart';

import 'card_with_icon_and_text.dart';
import 'filesharing_headline.dart';

Future<void> openMoveFilePage(
    {@required BuildContext context, @required CloudFile cloudFile}) async {
  await Navigator.push(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => BlocProvider(
        bloc: MoveFileBloc(
          cloudFile: cloudFile,
          fileSharingGateway:
              BlocProvider.of<SharezoneContext>(context).api.fileSharing,
        ),
        child: _MoveFilePage(),
      ),
    ),
  );
}

class _MoveFilePage extends StatelessWidget {
  const _MoveFilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoveFileBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Verschiebe ${bloc.cloudFile.name} nach"),
        centerTitle: true,
      ),
      body: _MoveFileCurrentPath(),
      bottomNavigationBar: _MoveFileBottomBar(),
    );
  }
}

class _MoveFileCurrentPath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoveFileBloc>(context);
    return StreamBuilder<TwoStreamSnapshot<FileSharingData, FolderPath>>(
      stream: bloc.moveFileState.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final fileSharingData = snapshot.data.data0;
        final currentPath = snapshot.data.data1;
        return Column(
          children: <Widget>[
            MoveFilePageHeader(
              currentPath: currentPath,
              fileSharingData: fileSharingData,
            ),
            _FolderList(
              fileSharingData: fileSharingData,
              folders:
                  fileSharingData.getFolders(currentPath)?.values?.toList() ??
                      [],
              courseID: fileSharingData.courseID,
              path: currentPath,
            )
          ],
        );
      },
    );
  }
}

class _FolderList extends StatelessWidget {
  const _FolderList(
      {@required this.folders,
      @required this.fileSharingData,
      @required this.courseID,
      @required this.path});

  final List<Folder> folders;
  final FileSharingData fileSharingData;
  final String courseID;
  final FolderPath path;

  @override
  Widget build(BuildContext context) {
    if (folders != null && folders.isEmpty) return _EmptyFoldersList();
    folders.sort((a, b) => a.name.compareTo(b.name));
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FileSharingHeadline(title: "Ordner"),
          WrappableList(
            minWidth: 150.0,
            maxElementsPerSection: 3,
            children: [
              for (final folder in folders)
                _FolderCard(
                  folder: folder,
                  fileSharingData: fileSharingData,
                  path: path.getChildPath(folder.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyFoldersList extends StatelessWidget {
  const _EmptyFoldersList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: const Center(
        child: Text(
            "Es befinden sich an diesem Ort keine weiteren Ordner... Navigiere zwischen den Ordnern über die Leiste oben."),
      ),
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({
    @required this.folder,
    @required this.path,
    this.fileSharingData,
  });

  final Folder folder;
  final FolderPath path;
  final FileSharingData fileSharingData;

  @override
  Widget build(BuildContext context) {
    return CardWithIconAndText(
      onTap: () {
        final moveFileBloc = BlocProvider.of<MoveFileBloc>(context);
        moveFileBloc.changeNewPath(path);
      },
      icon: Icon(Icons.folder, color: Colors.grey[600]),
      text: folder.name ?? "?",
    );
  }
}

class _MoveFileBottomBar extends StatelessWidget {
  const _MoveFileBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoveFileBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isMoveFileAllowed,
      builder: (context, snapshot) {
        final isMoveFileAllowed = snapshot.data ?? false;
        return BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).errorColor,
                child: Text("Abbrechen".toUpperCase()),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text("Verschieben".toUpperCase()),
                onPressed: isMoveFileAllowed
                    ? () {
                        bloc.moveFileToNewPath();
                        Navigator.pop(context);
                      }
                    : null,
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
