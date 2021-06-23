import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/gateway/imprint_gateway.dart';

import 'imprint_bloc.dart';

class ImprintBlocFactory extends BlocBase {
  final ImprintGateway _gateway;

  ImprintBlocFactory(this._gateway);

  ImprintBloc create() {
    return ImprintBloc(_gateway);
  }

  @override
  void dispose() {}
}
