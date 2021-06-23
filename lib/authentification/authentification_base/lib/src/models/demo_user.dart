import 'package:authentification_base/authentification.dart';

class DemoUser extends AuthUser {
  @override
  String get uid => "testUser";

  @override
  String get email => "test@sharezone.net";

  @override
  bool get isAnonymous => true;
}
