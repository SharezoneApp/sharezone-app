import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';

class FileSharingPageStateBloc extends BlocBase {
  final _stateSubject =
      BehaviorSubject<FileSharingPageState>.seeded(FileSharingPageStateHome());

  Stream<FileSharingPageState> get currentState => _stateSubject;
  Function(FileSharingPageState) get changeStateTo => _stateSubject.sink.add;

  FileSharingPageState get currentStateValue => _stateSubject.value;
  @override
  void dispose() {
    _stateSubject.close();
  }
}
