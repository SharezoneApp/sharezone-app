import 'package:app_functions/app_functions.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/util/api/schoolClassGateway.dart';

class SchoolClassEditGateway {
  final SchoolClassGateway _gateway;
  final SchoolClass _currentSchoolClass;

  SchoolClassEditGateway(this._gateway, this._currentSchoolClass);

  Future<AppFunctionsResult<bool>> edit(String name) async {
    final schoolClass = _currentSchoolClass.copyWith(name: name);
    return await _gateway.editSchoolClass(schoolClass);
  }
}
