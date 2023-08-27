// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

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
