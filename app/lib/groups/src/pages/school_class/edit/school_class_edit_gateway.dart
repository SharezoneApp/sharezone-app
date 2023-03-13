// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/util/api/school_class_gateway.dart';

class SchoolClassEditGateway {
  final SchoolClassGateway _gateway;
  final SchoolClass _currentSchoolClass;

  SchoolClassEditGateway(this._gateway, this._currentSchoolClass);

  Future<AppFunctionsResult<bool>> edit(String name) async {
    final schoolClass = _currentSchoolClass.copyWith(name: name);
    return await _gateway.editSchoolClass(schoolClass);
  }
}
