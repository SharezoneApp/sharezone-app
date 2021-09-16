import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/bloc/file_page_bloc.dart';
import 'package:sharezone_widgets/widgets.dart';

class FilePage extends StatefulWidget {
  static const tag = "file-page";

  const FilePage({
    Key key,
    @required this.fileType,
    this.actions,
    this.onLoadedFile,
    @required this.name,
    this.nameStream,
    @required this.downloadURL,
    @required this.id,
  })  : assert(fileType != null ||
            !(fileType == FileFormat.pdf ||
                fileType == FileFormat.image ||
                fileType == FileFormat.video)),
        super(key: key);

  final FileFormat fileType;
  final ValueChanged<LocalFile> onLoadedFile;
  final List<Widget> actions;

  final String name;
  final Stream<String> nameStream;
  final String downloadURL;
  final String id;

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  _FilePageState();

  FilePageBloc filePageBloc;

  FileFormat get fileFormat => widget.fileType;
  String get name => widget.name;

  @override
  void initState() {
    super.initState();
    filePageBloc ??= FilePageBloc(
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
        if (!snapshot.hasData || snapshot.data == null)
          return _LoadingPage(
            name: name,
            nameStream: widget.nameStream,
          );
        if (snapshot.hasError)
          return _EmptyPage(
            name: name,
            nameStream: widget.nameStream,
            error: snapshot.error,
          );
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
            localFile: localFile,
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
    Key key,
    @required this.name,
    @required this.nameStream,
  }) : super(key: key);

  final String name;
  final Stream<String> nameStream;

  @override
  __LoadingPageState createState() => __LoadingPageState();
}

class __LoadingPageState extends State<_LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColorBrightness: Brightness.dark),
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
    Key key,
    @required this.name,
    @required this.nameStream,
    this.error,
  }) : super(key: key);

  final String name;
  final Stream<String> nameStream;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilePageAppBar(name: name, nameStream: nameStream),
      body: Center(
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text("Anzeigefehler"),
          subtitle: error != null ? Text('$error') : null,
        ),
      ),
    );
  }
}
