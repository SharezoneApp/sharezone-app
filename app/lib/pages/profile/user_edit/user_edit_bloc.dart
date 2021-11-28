import 'package:app_functions/app_functions.dart';
import 'package:authentification_base/authentification.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:user/user.dart';

class UserEditPageBloc extends BlocBase with AuthentificationValidators {
  final _nameSubject = BehaviorSubject<String>();

  final UserEditBlocGateway _gateway;
  final String initalName;

  UserEditPageBloc({
    @required UserEditBlocGateway gateway,
    @required String name,
  })  : _gateway = gateway,
        initalName = name {
    _nameSubject.sink.add(name);
  }

  bool get hasInputChanged => initalName != _nameSubject.valueOrNull;

  Function(String) get changeName => _nameSubject.sink.add;
  Stream<String> get name => _nameSubject.stream.transform(validateName);

  Future<bool> submit() async {
    final name = _nameSubject.valueOrNull;

    if (hasInputChanged) {
      if (_isSubmitValid(name)) {
        final userInput = UserInput(name: name);
        final result = await _gateway.edit(userInput);
        return result.hasData && result.data == true;
      }
    } else
      throw SameNameAsBefore();

    return false;
  }

  bool _isSubmitValid(String name) {
    if (AuthentificationValidators.isNameValid(name)) {
      return true;
    } else {
      throw NameIsMissingException();
    }
  }

  @override
  void dispose() {
    _nameSubject.close();
  }
}

class UserInput {
  final String name;
  UserInput({
    @required this.name,
  });
}

class UserEditBlocGateway {
  final UserGateway _gateway;
  final AppUser _user;

  UserEditBlocGateway(this._gateway, this._user);

  Future<AppFunctionsResult<bool>> edit(UserInput userInput) {
    return _gateway.updateUser(_user.copyWith(
      name: userInput.name,
      abbreviation: _generateAbbreviation(userInput.name),
    ));
  }
}

String _generateAbbreviation(String name) {
  assert(name != null);
  return name.substring(0, 1).toUpperCase();
}
