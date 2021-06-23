import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_utils/streams.dart';

import 'user_view.dart';

class MyProfileBloc extends BlocBase {
  final Stream<UserView> userViewStream;

  MyProfileBloc(UserGateway userGateway)
      : userViewStream = TwoStreams(
                userGateway.userStream, userGateway.authUserStream)
            .stream
            .map((result) =>
                UserView.fromUserAndFirebaseUser(result.data0, result.data1));

  @override
  void dispose() {}
}
