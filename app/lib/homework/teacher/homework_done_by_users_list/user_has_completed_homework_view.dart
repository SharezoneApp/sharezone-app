import 'package:meta/meta.dart';
import 'package:user/user.dart';

class UserHasCompletedHomeworkView {
  final String uid;
  final String name;
  final String abbrevation;
  final bool hasDone;

  UserHasCompletedHomeworkView({
    @required this.uid,
    @required this.name,
    @required this.hasDone,
  }) : abbrevation = generateAbbreviation(name);
}
