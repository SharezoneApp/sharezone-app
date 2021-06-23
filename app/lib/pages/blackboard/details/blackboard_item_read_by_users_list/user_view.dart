import 'package:meta/meta.dart';
import 'package:user/user.dart';

class UserView {
  final String uid;
  final String name;
  final String abbrevation;
  final String typeOfUser;
  final bool hasRead;

  UserView({
    @required this.uid,
    @required this.name,
    @required this.hasRead,
    @required this.typeOfUser,
  }) : abbrevation = generateAbbreviation(name);
}
