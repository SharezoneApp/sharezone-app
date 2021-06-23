import 'implementation/stub_file_uploader.dart'
    if (dart.library.io) 'implementation/mobile_firebase_file_uploader.dart'
    if (dart.library.js) 'implementation/web_firebase_file_uploader.dart'
    as implementation;

import 'file_uploader.dart';

FileUploader getFileUploader() {
  return implementation.getFileUploaderImplementation();
}
