import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/util/api/blackboard_api.dart';

class BlackboardCardBloc extends BlocBase {
  final BlackboardGateway gateway;
  final String itemID;

  BlackboardCardBloc({@required this.gateway, @required this.itemID});

  void changeReadState(bool newState) =>
      gateway.changeIsBlackboardDoneTo(itemID, newState);

  @override
  void dispose() {}
}
