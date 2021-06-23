import 'file_saver.dart';
import 'implementation/stub_file_saver.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/mobile_file_saver.dart'
    if (dart.library.js) 'implementation/web_file_saver.dart' as implementation;

FileSaver getFileSaver() {
  return implementation.getFileSaver();
}
