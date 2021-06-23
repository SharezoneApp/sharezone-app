import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';
import 'models/cloud_storage_helper.dart';
import 'models/upload_task.dart';

export 'models/cloud_storage_helper.dart';

// ignore:one_member_abstracts
abstract class FileUploader {
  Future<UploadTask> uploadFile({
    @required CloudFile cloudFile,
    @required LocalFile file,
  });

  /// Lädt [localFile] zu Cloud Storage unter [cloudStoragePfad] hoch.
  /// Die [creatorId] wird mit dem Dateinamen als Metadaten gespeichert.
  Future<UploadTask> uploadFileToStorage(
      CloudStoragePfad cloudStoragePfad, String creatorId, LocalFile localFile,
      {String cacheControl});
}
