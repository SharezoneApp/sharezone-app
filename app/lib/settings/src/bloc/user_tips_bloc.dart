import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class UserTipsBloc extends BlocBase {
  final UserGateway _userGateway;

  UserTipsBloc(this._userGateway);

  Stream<UserTipData> streamUserTipData() {
    return _userGateway.userStream.map((user) => user?.userTipData);
  }

  void enableUserTip(UserTipKey tipKey) {
    _updateUserTip(tipKey, true);
  }

  void _updateUserTip(UserTipKey tipKey, bool newValue) {
    _userGateway.updateUserTip(tipKey, newValue);
  }

  @override
  void dispose() {}
}
