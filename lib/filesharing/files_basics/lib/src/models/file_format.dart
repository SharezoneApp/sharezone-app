import 'package:files_basics/local_file.dart';

enum FileFormat {
  unknown,
  pdf,
  text,
  image,
  video,
  zip,
  excel,
  audio,
}

FileFormat fileFormatEnumFromFilenameWithExtension(
    String filenameWithExtension) {
  final ff = FileUtils.getExtension(filenameWithExtension);
  return FileUtils.getFileFormatFromExtension(ff);
}

FileFormat fileTypeEnumFromString(String data) {
  return FileFormat.values
      .firstWhere((e) => e.toString() == 'FileFormat.$data');
}

String fileTypeEnumToString(FileFormat fileType) {
  return fileType.toString().split('.')[1];
}

class FileUtils {
  static const extensionsPDF = <String>['pdf'];
  static const extensionsTEXT = <String>['txt', 'doc', 'docx'];
  static const extensionsIMAGE = <String>['jpg', 'png', 'jpeg'];
  static const extensionsVIDEO = <String>['mp4', 'mkv', 'wmv', 'avi', 'm4a'];
  static const extensionsZIP = <String>['zip', 'rar', '7z'];
  static const extensionsEXCEL = <String>['xls'];
  static const extensionsAUDIO = <String>['mp3', 'wav'];

  static const mimeTypesPDF = <String>['application/pdf'];
  static const mimeTypesVIDEO = <String>['video/mp4'];
  static const mimeTypesZIP = <String>['application/zip'];
  static const mimeTypesIMAGE = <String>[
    'image/png',
    'image/jpeg',
    'image/jpg',
  ];
  static String getExtension(String filePath) {
    String fileExtension = "";
    int i = filePath.lastIndexOf('.');
    if (i > 0) {
      fileExtension = filePath.substring(i + 1);
    }
    return fileExtension.toLowerCase();
  }

  static FileFormat getFileFormatFromExtension(String fileExtension) {
    if (extensionsPDF.contains(fileExtension))
      return FileFormat.pdf;
    else if (extensionsTEXT.contains(fileExtension))
      return FileFormat.text;
    else if (extensionsIMAGE.contains(fileExtension))
      return FileFormat.image;
    else if (extensionsVIDEO.contains(fileExtension))
      return FileFormat.video;
    else if (extensionsZIP.contains(fileExtension))
      return FileFormat.zip;
    else if (extensionsEXCEL.contains(fileExtension))
      return FileFormat.excel;
    else if (extensionsAUDIO.contains(fileExtension))
      return FileFormat.audio;
    else
      return FileFormat.unknown;
  }

  static FileFormat getFileFormatFromMimeType(MimeType mimeType) {
    final mimeTypeAsString = mimeType.toData();
    // FILEFORMAT.PDF
    if (mimeTypesPDF.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsPDF)) {
      return FileFormat.pdf;
      // FILEFORMAT.TEXT
    } else if (_mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsTEXT))
      return FileFormat.text;
    // FILEFORMAT.IMAGE
    else if (mimeTypesIMAGE.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsIMAGE) ||
        mimeTypeAsString.contains('image'))
      return FileFormat.image;
    // FILEFORMAT.VIDEO
    else if (mimeTypesVIDEO.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsVIDEO) ||
        mimeTypeAsString.contains('video'))
      return FileFormat.video;
    // FILEFORMAT.ZIP
    else if (extensionsZIP.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsZIP))
      return FileFormat.zip;
    // FILEFORMAT.EXCEL
    else if (extensionsEXCEL.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsEXCEL))
      return FileFormat.excel;
    // FILEFORMAT.AUDIO
    else if (extensionsAUDIO.contains(mimeTypeAsString) ||
        _mimeTypeContainsAnyOfTheseExtensions(mimeType, extensionsAUDIO) ||
        mimeTypeAsString.contains('audio'))
      return FileFormat.audio;
    else
      return FileFormat.unknown;
  }

  static bool _mimeTypeContainsAnyOfTheseExtensions(
      MimeType mimeType, List<String> extensions) {
    final mimeTypeString = mimeType.toData();
    for (final extensionString in extensions) {
      if (mimeTypeString.contains(extensionString)) {
        return true;
      }
    }
    return false;
  }
}
