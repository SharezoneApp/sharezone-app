import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';

class MissingAccountInformationGuardBloc extends BlocBase {
  final UserGateway userGateway;

  final Stream<bool> hasUserSharezoneAccount;

  MissingAccountInformationGuardBloc(this.userGateway)
      : hasUserSharezoneAccount =
            userGateway.userDocument.map((doc) => doc.exists);

  Future<void> logOut() => userGateway.logOut();

  @override
  void dispose() {}
}
