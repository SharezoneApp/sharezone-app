import 'package:common_domain_models/common_domain_models.dart';

abstract class AbgabefristStreamer {
  Stream<DateTime> streamAbgabezeitpunktFuerHausaufgabe(HomeworkId homeworkId);
}
