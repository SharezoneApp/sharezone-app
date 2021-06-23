import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:abgabe_client_lib/src/models/abgegebene_abgabe.dart';
import 'package:abgabe_client_lib/src/models/hochgeladene_abgabedatei.dart';
import 'package:abgabe_client_lib/src/models/nutzername.dart';

import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart' as rx;

class ViewSubmissionsPageBloc extends BlocBase {
  Stream<CreatedSubmissionsPageView> get pageView => _pageViewSubject;
  final _pageViewSubject = rx.BehaviorSubject<CreatedSubmissionsPageView>();

  // Man könnte hier auch die Factory und den Bloc kombinieren.
  final Stream<DateTime> abgabedatumStream;
  final Stream<List<Nutzer>> vonAbgabeBetroffendeNutzer;
  final Stream<List<AbgegebeneAbgabe>> abgegebeneAbgaben;

  ViewSubmissionsPageBloc({
    @required final HomeworkId homeworkId,
    @required this.abgabedatumStream,
    @required this.abgegebeneAbgaben,
    @required this.vonAbgabeBetroffendeNutzer,
  }) {
    // Muss der Stream geschlossen werden?
    rx.CombineLatestStream.combine3<List<AbgegebeneAbgabe>, DateTime,
            List<Nutzer>, CreatedSubmissionsPageView>(
        abgegebeneAbgaben, abgabedatumStream, vonAbgabeBetroffendeNutzer,
        (abgaben, abgabefrist, betroffendeNutzer) {
      // * Für alle Nutzer, die keine Abgabe haben eine "nicht abgegeben"-View
      // erstellen
      final userIds = abgaben.map((e) => e.author.id).toSet();
      final nutzerOhneAbgaben =
          betroffendeNutzer.where((event) => !userIds.contains(event.id));
      final ohneAbgabenViews = [
        for (final nutzer in nutzerOhneAbgaben)
          NotSubmittedView(
            abbreviation: nutzer.name.abbreviation,
            username: nutzer.name.ausgeschrieben,
          )
      ];

      final zuSpaeteAbgaben = abgaben
          .where((abgabe) => abgabe.wurdeAbgegebenNach(abgabefrist))
          .map((abgabe) => abgabe.toView())
          .toList();

      final puentklicheAbgaben = abgaben
          .where((abgabe) => !abgabe.wurdeAbgegebenNach(abgabefrist))
          .map((abgabe) => abgabe.toView())
          .toList();

      return CreatedSubmissionsPageView(
        missingSubmissions: ohneAbgabenViews,
        afterDeadlineSubmissions: zuSpaeteAbgaben,
        submissions: puentklicheAbgaben,
      );
    }).listen((value) {
      _pageViewSubject.add(value);
    });
  }

  @override
  void dispose() {
    _pageViewSubject.close();
  }
}

class Nutzer {
  final UserId id;
  final Nutzername name;

  Nutzer({
    @required this.id,
    @required this.name,
  });
}

extension on AbgegebeneAbgabe {
  CreatedSubmissionView toView() {
    return CreatedSubmissionView(
      abbreviation: author.name.abbreviation,
      username: author.name.ausgeschrieben,
      submittedFiles: abgegebeneDateien.map((datei) => datei.toView()).toList(),
      lastActionDateTime: letzteAktion,
      wasEditedAfterwards: zuletztBearbeitet.isPresent,
    );
  }
}

extension on HochgeladeneAbgabedatei {
  CreatedFileView toView() {
    return CreatedFileView(
      id: id.toString(),
      format: format,
      title: name.mitExtension,
      downloadUrl: downloadUrl.toString(),
    );
  }
}
