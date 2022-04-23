// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:abgabe_client_lib/src/erstellung/bloc/lokale_abgabedatei_factory.dart';
import 'package:abgabe_client_lib/src/erstellung/datei_upload_prozess.dart';
import 'package:abgabe_client_lib/src/erstellung/local_file_saver.dart';
import 'package:abgabe_client_lib/src/erstellung/lokale_abgabedatei.dart';
import 'package:abgabe_client_lib/src/erstellung/uploader/abgabedatei_uploader.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/abgabe_veroeffentlicher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_loescher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_umbenenner.dart';
import 'package:abgabe_client_lib/src/erstellung/views.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

import 'package:bloc_base/bloc_base.dart';
import 'package:built_collection/built_collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:rxdart/subjects.dart';
import 'contains_where_extension.dart';

import 'local_files_to_abgabedatei.dart';
import 'namens_deduplizierung.dart';
import 'view_erstellung.dart';

typedef ErrorRecorder = Future<void> Function(
    dynamic exception, StackTrace stack);

typedef AbgabedateiIdGenerator = AbgabedateiId Function(LocalFile localFile);

AbgabedateiId randomAbgabedateiId(LocalFile localFile) =>
    AbgabedateiId(AutoIdGenerator.autoId());

class HomeworkUserCreateSubmissionsBloc extends BlocBase {
  final AbgabeId _abgabeId;
  final AbgabedateiHochlader _dateiUploader;
  final SingletonLocalFileSaver _fileSaver;
  final AbgabendateiUmbenenner _dateiUmbenenner;
  final AbgabendateiLoescher _dateiLoescher;
  final ErrorRecorder _recordError;
  final Stream<DateTime> _abgabezeitpunkt;
  final DateTime Function() _getCurrentDateTime;
  final rx.ValueStream<ErstellerAbgabeModelSnapshot> _aktuelleAbgabe;
  final AbgabedateiIdGenerator _generiereAbgabedateiId;
  final AbgabeVeroeffentlicher _abgabenVeroeffentlicher;
  LocalFileAbgabedateiKonvertierer _localFileKonvertierer;
  LokaleAbgabedateiFactory _lokaleAbgabedateiFactory;

  Stream<SubmissionPageView> get pageView => _pageViewSubject;
  final _pageViewSubject = BehaviorSubject<SubmissionPageView>();

  Stream<SubmissionDeadlineState> _currentDeadlineState;
  final _hochladeneDateien =
      BehaviorSubject<BuiltList<HochladeneLokaleAbgabedatei>>.seeded(
          BuiltList<HochladeneLokaleAbgabedatei>());

  StreamSubscription _viewsSubscription;

  HomeworkUserCreateSubmissionsBloc(
    this._abgabeId,
    this._recordError,
    this._fileSaver,
    AbgabedateiUploader dateiUploader,
    Stream<ErstellerAbgabeModelSnapshot> aktuelleAbgabe,
    this._dateiLoescher,
    this._dateiUmbenenner,
    this._abgabenVeroeffentlicher,
    this._abgabezeitpunkt,
    this._getCurrentDateTime, {

    /// Wird über Parameter gemacht, damit Tests das hier mocken können
    /// Das generien einer ID ist dafür da, dass eine Datei lokal und auf dem
    /// Server als eine erkenntlich ist, unabhängig von dem Pfad oder Namen.
    AbgabedateiIdGenerator generiereAbgabedateiId,

    /// Wie oft geguckt werden soll, wie der aktuelle [SubmissionDeadlineState]
    /// ist. Wird beim testen hoch gestellt, damit die Tests schneller
    /// durchlaufen.
    Duration abgabefristUeberwachungsfrequenz,
  })  : _generiereAbgabedateiId = generiereAbgabedateiId ?? randomAbgabedateiId,
        _aktuelleAbgabe = aktuelleAbgabe.shareValue(),
        _dateiUploader = AbgabedateiHochlader(dateiUploader, _abgabeId) {
    _lokaleAbgabedateiFactory =
        LokaleAbgabedateiFactory(_generiereAbgabedateiId, _getCurrentDateTime);
    _localFileKonvertierer = LocalFileAbgabedateiKonvertierer(
      _lokaleAbgabedateiFactory,
      _recordError,
    );
    _currentDeadlineState = rx.CombineLatestStream.combine2<DateTime, void,
        SubmissionDeadlineState>(
      _abgabezeitpunkt,
      Stream.periodic(abgabefristUeberwachungsfrequenz ?? Duration(seconds: 1))
          .startWith(null),
      (abgabezeitpunkt, _) =>
          _getDeadlineState(abgabezeitpunkt, _getCurrentDateTime()),
    ).distinct();
    final views = rx.CombineLatestStream.combine3<
            SubmissionDeadlineState,
            ErstellerAbgabeModelSnapshot,
            BuiltList<HochladeneLokaleAbgabedatei>,
            SubmissionPageView>(
        _currentDeadlineState, _aktuelleAbgabe, _hochladeneDateien,
        (state, abgabenSnapshot, hochladeneDateien) {
      /// Noch keine Dateien erfolgreich hochgeladen
      if (!abgabenSnapshot.existiertAbgabe) {
        return SubmissionPageView(
          submittable: false,
          submitted: false,
          deadlineState: state,
          files: [
            if (hochladeneDateien != null)
              for (final hochladeneDatei in hochladeneDateien)
                hochladeneDatei.toView()
          ],
        );

        /// Es gibt schon erfolgreich hochgeladene Dateien, vielleicht wurde
        /// die Abgabe auch schon abgegeben.
      } else {
        final hochgeladeneDateien = abgabenSnapshot.abgabe.value.abgabedateien;
        final nurLokaleDateien = hochladeneDateien.where((datei) =>
            !hochgeladeneDateien.containsWhere((hd) => hd.id == datei.id));

        final sindMancheHochladeneDateienFertigHochgeladen =
            hochladeneDateien.length != nurLokaleDateien.length;
        if (sindMancheHochladeneDateienFertigHochgeladen) {
          /// Entfernt alle hochladenen Dateien für die nächsten "Durchläufe",
          /// die bereits am Server angekommen sind.
          ///
          /// Der Grund dafür ist, dass momentan noch die Chance besteht,
          /// dass im Backend bei zu vielen schnell hintereinander hochladenen
          /// Dateien eine bereits hochgeladene Datei aus der Abgabe entfernt
          /// wird.
          /// Das würde der Nutzer aber, falls die bereits hochgeladenen
          /// Dateien nicht wie hier lokal entfernt werden, nicht bemerken,
          /// weil dann wieder die "erfolgreich" lokal hochgeladene Datei
          /// anstatt der Datei vom Backend angezeigt werden würde.
          ///
          /// So verschwindet die Datei aus der Liste, falls die Datei vom
          /// Backend entfernt wird und der Nutzer versucht im besten Fall
          /// nochmals diese hochzuladen und denkt nicht,
          /// dass er eine Datei abgibt, die so gar nicht mehr existiert.
          _hochladeneDateien.add(nurLokaleDateien.toBuiltList());
        }

        final sortiereDateien = List<Abgabedatei>.from(
            [...nurLokaleDateien, ...hochgeladeneDateien])
          ..sort((a, b) => a.erstellungsdatum.compareTo(b.erstellungsdatum));

        final views = sortiereDateien.map((e) => e.toView()).toList();

        /// Wenn man abgibt, während eine Datei hochlädt, dann würde das dazu
        /// führen, dass beim Lehrer ein "nachträglich bearbeitet" angezeigt
        /// wird, wenn die Datei fertig hochgeladen wurde, was wahrscheinlich
        /// nicht im Sinne der Nutzer ist.
        final keineDateiAmHochladen = hochladeneDateien
            .where((hochladeneDatei) =>
                hochladeneDatei.fortschritt.status == FileViewStatus.uploading)
            .isEmpty;
        final istAbgebbar =
            hochgeladeneDateien.isNotEmpty && keineDateiAmHochladen;

        return SubmissionPageView(
          submittable: istAbgebbar,
          deadlineState: state,
          files: views,
          submitted:
              abgabenSnapshot.abgabe.map((val) => val.abgegeben).orElse(false),
        );
      }
    });

    _viewsSubscription = views.listen((state) {
      _pageViewSubject.add(state);
    });
  }

  /// Startet den Upload-Prozess für [localFiles].
  ///
  /// Falls Dateien mit dem selben Namen hinzugefügt werden, dann wird für diese
  /// ein Ersatzname gesucht, sodass jede Datei ein einzigartigen Namen hat.
  ///
  /// Falls ein [LocalFile] nicht zu [LokaleAbgabedatei] konvertiert werden kann
  /// wird eine [FileConversionException] geworfen.
  /// Die erfolgreich konvertierten Dateien werden trotzdem versucht
  /// hochzuladen.
  Function(List<LocalFile> localFiles) get addSubmissionFiles =>
      (localFiles) async {
        final res = _localFileKonvertierer.konvertiereLocalFiles(localFiles);

        final aktuelleAbgabe =
            _aktuelleAbgabe?.valueOrNull?.abgabe?.orElse(null);
        final hochgeladeneNamen =
            aktuelleAbgabe?.abgabedateien?.map((e) => e.name)?.toSet() ?? {};

        final hochladeneNamen =
            _hochladeneDateien.valueOrNull.map((datei) => datei.name).toSet();
        final bereitsVorhandeneNamen = hochgeladeneNamen.union(hochladeneNamen);

        final einzigartigBenannteDateien = benenneEinzigartig(
          res.konvertierteDateien,
          bereitsVorhandeneDateinamen: bereitsVorhandeneNamen,
        );

        for (var datei in einzigartigBenannteDateien) {
          _fileSaver.saveFile('${datei.id}', datei.localFile);
        }

        for (var abgabedatei in einzigartigBenannteDateien) {
          var hochladeneDatei = HochladeneLokaleAbgabedatei(
              abgabedatei, Fortschritt.nichtGestartet());
          final aktuelleDateien =
              _hochladeneDateien.valueOrNull.add(hochladeneDatei);
          _hochladeneDateien.add(aktuelleDateien);

          _dateiUploader.ladeDateiHoch(abgabedatei).listen((_datei) {
            final neu = _hochladeneDateien.valueOrNull.replace(_datei);
            _hochladeneDateien.add(neu);
          });
        }

        if (res.hatUnkonvertierteDateien) {
          throw FileConversionException(res.unkonvertierbareDateien);
        }
      };

  /// Entfernt die Datei mit der Id [fileId].
  ///
  /// Falls die Datei nicht erfolgreich hochgeladen wurde wird nur die lokale
  /// Referenz aus der [SubmissionPageView] entfernt - es passiert nichts mit
  /// der Datei auf dem Gerät.
  /// Falls die Datei erfolgreich wurde, dann wird versucht die Datei vom Server
  /// zu löschen.
  ///
  /// Falls die Funktion außer in den oben genannten Fällen aufgerufen wird ist
  /// das Verhalten undefiniert - Dort sollte der Nutzer nämlich die Funktion
  /// gar nicht aufrufen können.
  ///
  /// Die [fileId] kann von der [FileView] gelesen werden.
  Function(String fileId) get removeSubmissionFile => (fileId) async {
        final file = _hochladeneDateien.valueOrNull.firstWhere(
          (datei) => '${datei.id}' == fileId,
          orElse: () => null,
        );
        if (file != null) {
          final neu = _hochladeneDateien.valueOrNull.rebuild(
              (files) => files.removeWhere((datei) => '${datei.id}' == fileId));
          _hochladeneDateien.add(neu);
        }
        final abgabeSnapshot = _aktuelleAbgabe.valueOrNull;
        if (abgabeSnapshot.existiertAbgabe) {
          final abgabe = abgabeSnapshot.abgabe.value;
          final hatDateiMitId = abgabe.abgabedateien
              .where((element) => element.id == AbgabedateiId(fileId))
              .isNotEmpty;
          if (hatDateiMitId) {
            await _dateiLoescher.loescheDatei(AbgabedateiId(fileId));
            return;
          }
        }
      };

  /// Die "Basenamese" aller Dateien, unabhängig davon wie der Hochladestatus
  /// ist. Der Basename ist der Dateiname ohne Extension.
  /// Für "meine-datei.pdf" ist der Basename beispielsweise "meine-datei".
  /// Der Stream wird von der UI für den Umbenennungsdialog genutzt, damit dort
  /// vor einem bereits vorhandenen Namen gewarnt werden kann.
  Stream<List<String>> get submissionFileBasenames =>
      pageView.map((view) => view.files.map((file) => file.basename).toList());

  /// Ändert den Basename einer hochgeladenen Datei mit der Id [fileId]
  /// zu [newBasename] auf dem Server um.
  /// Da alle Dateien direkt hochgeladen werden, soll diese Funktion nur bei
  /// hochgeladenen Dateien aufgerufen werden.
  /// Ansonsten ist das Verhalten undefiniert.
  Future<void> renameFile(String fileId, String newBasename) async {
    final abgabeSnapshot = _aktuelleAbgabe.valueOrNull;
    if (abgabeSnapshot.existiertAbgabe) {
      final abgabe = abgabeSnapshot.abgabe.value;
      final datei = abgabe.abgabedateien.firstWhere(
          (element) => element.id == AbgabedateiId(fileId),
          orElse: () => null);
      if (datei != null) {
        final neuerName = datei.name.neuerBasename(newBasename);
        await _dateiUmbenenner.nenneDateiUm(datei.id, neuerName);
      }
    }
  }

  /// Versucht die Abgabe zu veröffentlichen.
  /// Prüft intern nicht anhand der lokal vorhandenen Daten, ob die Abgabe
  /// wirklich schon abgebbar ist - es wird direkt der Veröffentlichungs-Befehl
  /// an das Backend geschickt.
  /// Die UI sollte dahher nach bester Möglichkeit
  /// [SubmissionPageView.submittable] befolgen.
  Future<void> veroeffentlicheAbgabe() async {
    await _abgabenVeroeffentlicher.veroeffentlicheAbgabe(_abgabeId);
  }

  @override
  void dispose() {
    _pageViewSubject.close();
    _pageViewSubject.close();
    _viewsSubscription.cancel();
  }
}

class AbgabedateiHochlader {
  final AbgabedateiUploader _uploader;
  final AbgabeId _abgabeId;

  AbgabedateiHochlader(this._uploader, this._abgabeId);

  Stream<HochladeneLokaleAbgabedatei> ladeDateiHoch(Abgabedatei datei) {
    return _uploader
        .ladeAbgabedateiHoch(
          DateiHinzufuegenCommand(
            abgabeId: _abgabeId,
            dateiId: datei.id,
            dateiname: datei.name,
          ),
        )
        .asBroadcastStream()
        .map((event) => HochladeneLokaleAbgabedatei(
              datei,
              Fortschritt.fromDateiUploadProzessFortschritt(event),
            ));
  }
}

/// Falls ein [LocalFile] nicht in eine [LokaleAbgabedatei] umgewandelt werden kann.
/// Das könnte möglicherweise passieren, falls ein im Dateisystem valider Name
/// nicht ein gültiger [Dateiname] ist. Wir sind uns nicht sicher welche
/// Garantien für Dateien bei welchem Gerät wie herrschen, weshalb wir dafür
/// ein Error erstellt haben.
class FileConversionException implements Exception {
  final List<LocalFile> files;

  FileConversionException(this.files);
}

extension on BuiltList<HochladeneLokaleAbgabedatei> {
  BuiltList<HochladeneLokaleAbgabedatei> add(
          HochladeneLokaleAbgabedatei datei) =>
      rebuild((list) => list.add(datei));

  BuiltList<HochladeneLokaleAbgabedatei> replace(
      HochladeneLokaleAbgabedatei datei) {
    return rebuild((list) {
      list.removeWhere((_datei) => _datei.id == datei.id);
      list.add(datei);
    });
  }
}

class Fortschritt {
  final Optional<double> inProzent;
  final FileViewStatus status;

  Fortschritt({
    @required this.inProzent,
    @required this.status,
  });

  factory Fortschritt.nichtGestartet() {
    return Fortschritt(
      inProzent: Optional.empty(),
      status: FileViewStatus.unitiated,
    );
  }

  factory Fortschritt.fromDateiUploadProzessFortschritt(
      DateiUploadProzessFortschritt _fortschritt) {
    FileViewStatus status;
    switch (_fortschritt.status) {
      case UploadStatusEnum.imGange:
        status = FileViewStatus.uploading;
        break;
      case UploadStatusEnum.erfolgreich:
        status = FileViewStatus.succesfullyUploaded;
        break;
      case UploadStatusEnum.fehlgeschlagen:
        status = FileViewStatus.failed;
        break;
    }

    return Fortschritt(
      inProzent: _fortschritt.fortschrittInProzent,
      status: status,
    );
  }

  @override
  String toString() => 'Fortschritt(inProzent: $inProzent, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Fortschritt && o.inProzent == inProzent && o.status == status;
  }

  @override
  int get hashCode => inProzent.hashCode ^ status.hashCode;
}

class HochladeneLokaleAbgabedatei extends LokaleAbgabedatei {
  final Fortschritt fortschritt;

  HochladeneLokaleAbgabedatei(LokaleAbgabedatei datei, this.fortschritt)
      : super(
          id: datei.id,
          name: datei.name,
          dateigroesse: datei.dateigroesse,
          erstellungsdatum: datei.erstellungsdatum,
          pfad: datei.pfad.orElse(null),
          localFile: datei.localFile,
        );

  @override
  String toString() =>
      'HochladeneDatei(datei: ${super.toString()}, fortschritt: $fortschritt)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HochladeneLokaleAbgabedatei &&
        o.pfad == pfad &&
        o.fortschritt == fortschritt;
  }

  @override
  int get hashCode => fortschritt.hashCode;
}

SubmissionDeadlineState _getDeadlineState(
    DateTime abgabezeitpunkt, DateTime now) {
  var compareTo = now.compareTo(abgabezeitpunkt);
  if (compareTo < 0) {
    return SubmissionDeadlineState.beforeDeadline;
  } else if (compareTo == 0) {
    return SubmissionDeadlineState.onDeadline;
  } else {
    return SubmissionDeadlineState.afterDeadline;
  }
}
