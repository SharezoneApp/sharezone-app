import 'package:abgabe_client_lib/src/models/models.dart';
import 'package:abgabe_client_lib/src/shared/abgabefrist_streamer.dart';

import 'package:common_domain_models/common_domain_models.dart';

abstract class AbnahmeErstellungGateway implements AbgabefristStreamer {
  Stream<ErstellerAbgabeModelSnapshot> streamAbgabe(
      final HomeworkId homeworkId);
}
