import 'file_downloader.dart';
import 'implementation/stub_file_downloader.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/mobile_file_downloader.dart'
    if (dart.library.js) 'implementation/web_file_downloader.dart'
    as implementation;

FileDownloader getFileDownloader() {
  return implementation.getFileDownloader();
}
