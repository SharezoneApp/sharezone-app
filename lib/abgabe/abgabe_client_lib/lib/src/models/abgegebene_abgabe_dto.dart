import 'package:meta/meta.dart';

import 'models.dart';

class AbgegebeneAbgabeDto {
  final String id;
  final AbgabezielReferenz submittedForShortReference;
  final AuthorDto author;
  final String lastEditedIsoString;
  final String submittedOnIsoString;
  final List<HochgeladeneAbgabedateiDto> submittedFiles;

  AbgegebeneAbgabeDto({
    @required this.author,
    @required this.submittedOnIsoString,
    @required this.lastEditedIsoString,
    @required this.id,
    @required this.submittedForShortReference,
    @required this.submittedFiles,
  });

  factory AbgegebeneAbgabeDto.fromData(String id, Map<String, dynamic> data) {
    return AbgegebeneAbgabeDto(
      id: id,
      author: AuthorDto.fromData(data['author']),
      submittedOnIsoString: data['submittedOn'],
      lastEditedIsoString: data['lastEdited'],
      submittedForShortReference:
          AbgabezielReferenz.fromMap(data['submittedForReference']),
      submittedFiles: decodeList(data['submittedFiles'],
          (it) => HochgeladeneAbgabedateiDto.fromData(it)),
    );
  }
}
