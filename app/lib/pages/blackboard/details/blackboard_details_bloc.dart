import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/widgets/blackboard/blackboard_view.dart';

class BlackboardDetailsBloc extends BlocBase {
  final BlackboardGateway gateway;
  final String itemID, uid;
  final Stream<BlackboardView> view;

  BlackboardDetailsBloc(
      this.gateway, this.itemID, this.uid, CourseGateway courseGateway)
      : view = gateway.singleBlackboardItem(itemID).map((item) =>
            BlackboardView.fromBlackboardItem(item, uid, courseGateway));

  void changeReadStatus(bool newValue) =>
      gateway.changeIsBlackboardDoneTo(itemID, newValue);

  @override
  void dispose() {}
}
