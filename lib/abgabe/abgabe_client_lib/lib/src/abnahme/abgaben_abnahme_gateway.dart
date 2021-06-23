import 'package:abgabe_client_lib/src/models/abgegebene_abgabe.dart';
import 'package:abgabe_client_lib/src/shared/abgabefrist_streamer.dart';
import 'package:common_domain_models/common_domain_models.dart';

import 'view_submissions_page_bloc.dart';

abstract class AbgabenAbnahmeGateway implements AbgabefristStreamer {
  Stream<List<AbgegebeneAbgabe>> streamAbgabenFuerHausaufgabe(
      final HomeworkId homeworkId);
  Stream<List<Nutzer>> vonAbgabeBetroffendeNutzer(AbgabeId abgabeId);
}
