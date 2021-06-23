import 'package:files_basics/local_file.dart';

abstract class FileDownloader {
  Future<LocalFile> downloadFileFromURL(String url, String filename, String id);
}
