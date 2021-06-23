import 'package:abgabe_client_lib/src/abnahme/view_submissions_page_bloc.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

import 'abgaben_abnahme_gateway.dart';

class ViewSubmissionsPageBlocFactory extends BlocBase {
  ViewSubmissionsPageBlocFactory({
    @required this.gateway,
    @required this.nutzerId,
  });

  final AbgabenAbnahmeGateway gateway;
  final UserId nutzerId;

  ViewSubmissionsPageBloc create(String homeworkId) {
    var _homeworkId = HomeworkId(homeworkId);
    final abgabeId = AbgabeId(AbgabezielId.homework(_homeworkId), nutzerId);

    return ViewSubmissionsPageBloc(
      homeworkId: _homeworkId,
      abgabedatumStream:
          gateway.streamAbgabezeitpunktFuerHausaufgabe(_homeworkId),
      abgegebeneAbgaben: gateway.streamAbgabenFuerHausaufgabe(_homeworkId),
      vonAbgabeBetroffendeNutzer: gateway.vonAbgabeBetroffendeNutzer(abgabeId),
    );
  }

  @override
  void dispose() {}
}
