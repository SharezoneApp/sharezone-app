import 'package:abgabe_client_lib/src/erstellung/bloc/homework_user_submissions_bloc.dart';
import 'package:abgabe_client_lib/src/erstellung/views.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

extension AbgabedateiToView on Abgabedatei {
  FileView toView() {
    if (this is HochladeneLokaleAbgabedatei) {
      // Sodass Dart die Extension-Methoden unten benutzt.
      HochladeneLokaleAbgabedatei d = this;
      return d.toView();
    } else if (this is HochgeladeneAbgabedatei) {
      HochgeladeneAbgabedatei d = this;
      return d.toView();
    }
    throw UnimplementedError('$runtimeType to $FileView is not implemented');
  }
}

extension HochladeneDateiToView on HochladeneLokaleAbgabedatei {
  FileView toView() => FileView(
        id: '$id',
        path: pfad,
        basename: name.ohneExtension,
        extentionName: name.nurExtension,
        fileFormat: format,
        status: fortschritt.status,
        uploadProgess: fortschritt.inProzent.orElse(null),
      );
}

extension HochgeladeneAbgabedateiToView on HochgeladeneAbgabedatei {
  FileView toView() => FileView(
        id: '$id',
        extentionName: name.nurExtension,
        basename: name.ohneExtension,
        status: FileViewStatus.succesfullyUploaded,
        fileFormat: format,
        downloadUrl: downloadUrl.toString(),
      );
}
