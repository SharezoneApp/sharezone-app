import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/settings/src/subpages/imprint/gateway/imprint_gateway.dart';

class ImprintBloc extends BlocBase {
  final ImprintGateway _gateway;

  ImprintBloc(this._gateway);

  Stream<String> get markdownStream =>
      _gateway.imprintStream.map((imprint) => imprint.asMarkdown);

  @override
  void dispose() {}
}
