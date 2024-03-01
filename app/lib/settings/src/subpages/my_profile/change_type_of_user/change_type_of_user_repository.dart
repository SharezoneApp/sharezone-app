import 'package:cloud_functions/cloud_functions.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserRepository {
  final FirebaseFunctions _functions;

  const ChangeTypeOfUserRepository({
    required FirebaseFunctions functions,
  }) : _functions = functions;

  Future<void> changeTypeOfUser(TypeOfUser typeOfUser) async {
    final callable = _functions.httpsCallable('changeTypeOfUser');
    await callable.call({
      'type': typeOfUser.name,
    });
  }
}
