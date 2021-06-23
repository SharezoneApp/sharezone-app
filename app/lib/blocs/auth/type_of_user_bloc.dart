import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user/user.dart';

class TypeOfUserBloc extends BlocBase {
  final _typeOfUserSubject = BehaviorSubject<TypeOfUser>();
  Stream<TypeOfUser> get typeOfUserStream => _typeOfUserSubject;

  TypeOfUserBloc(Stream<TypeOfUser> typeOfUserStream) {
    typeOfUserStream.listen(_typeOfUserSubject.add);
  }

  @override
  void dispose() {
    _typeOfUserSubject.close();
  }
}
