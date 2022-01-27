// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_edit_gateway.dart';
import 'package:sharezone/groups/src/pages/school_class/edit/school_class_validators.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/validators.dart';

class SchoolClassEditBloc extends BlocBase with SchoolClassValidators {
  SchoolClassEditBloc({@required this.gateway, @required this.currentName}) {
    _nameSubject.sink.add(currentName);
  }

  final SchoolClassEditGateway gateway;
  final String currentName;

  final _nameSubject = BehaviorSubject<String>();
  Function(String) get changeName => _nameSubject.sink.add;
  Stream<String> get name => _nameSubject.stream.transform(validateName);

  Future<bool> submit() async {
    if (_isSubmitValid()) {
      final name = _nameSubject.valueOrNull;
      final result = await gateway.edit(name);
      return result.hasData && result.data == true;
    }
    return false;
  }

  /// Validates, if the name is not empty and is not the same as before.
  bool _isSubmitValid() {
    final newName = _nameSubject.valueOrNull;
    final validator = NotEmptyOrNullValidator(newName);
    if (!validator.isValid()) {
      _nameSubject.addError(EmptyNameException().toString());
      throw EmptyNameException();
    } else {
      if (currentName == newName) {
        _nameSubject.addError(SameNameException().toString());
        throw SameNameException();
      } else {
        return true;
      }
    }
  }

  @override
  void dispose() {
    _nameSubject.close();
  }
}
