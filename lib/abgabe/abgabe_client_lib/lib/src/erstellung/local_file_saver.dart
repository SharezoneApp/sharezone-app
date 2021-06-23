import 'package:files_basics/local_file.dart';
import 'package:optional/optional.dart';

final Map<String, LocalFile> _files = {};

/// Behält die Dateien auch wenn eine neue Instanz erstellt wird.
class SingletonLocalFileSaver {
  void saveFile(String id, LocalFile file) {
    _files[id] = file;
  }

  Optional<LocalFile> getFile(String id) {
    return Optional.ofNullable(_files[id]);
  }
}
