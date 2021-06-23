import 'package:bloc_base/bloc_base.dart';
import 'package:files_basics/local_file.dart';
import 'package:files_usecases/file_downloader.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

class FilePageBloc extends BlocBase {
  final _localFileSubject = BehaviorSubject<LocalFile>();

  FilePageBloc(
      {@required String downloadURL,
      @required String name,
      @required String id}) {
    getFileDownloader()
        .downloadFileFromURL(downloadURL, name, id)
        .then((localFile) {
      _localFileSubject.add(localFile);
    }).catchError((e) {
      print(e);
      _localFileSubject.addError(e);
    });
  }

  Stream<LocalFile> get localFile => _localFileSubject;

  @override
  void dispose() {
    _localFileSubject.close();
  }
}
