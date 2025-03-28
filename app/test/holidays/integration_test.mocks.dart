// Mocks generated by Mockito 5.4.5 from annotations
// in sharezone/test/holidays/integration_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:app_functions/app_functions.dart' as _i2;
import 'package:app_functions/src/sharezone_app_functions.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAppFunctionsResult_0<T> extends _i1.SmartFake
    implements _i2.AppFunctionsResult<T> {
  _FakeAppFunctionsResult_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [SharezoneAppFunctions].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharezoneAppFunctions extends _i1.Mock
    implements _i3.SharezoneAppFunctions {
  @override
  _i4.Future<_i2.AppFunctionsResult<dynamic>> joinGroupByValue({
    required String? enteredValue,
    required String? memberID,
    List<String>? coursesForSchoolClass,
    int? version = 2,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#joinGroupByValue, [], {
              #enteredValue: enteredValue,
              #memberID: memberID,
              #coursesForSchoolClass: coursesForSchoolClass,
              #version: version,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<dynamic>>.value(
              _FakeAppFunctionsResult_0<dynamic>(
                this,
                Invocation.method(#joinGroupByValue, [], {
                  #enteredValue: enteredValue,
                  #memberID: memberID,
                  #coursesForSchoolClass: coursesForSchoolClass,
                  #version: version,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<dynamic>>.value(
                  _FakeAppFunctionsResult_0<dynamic>(
                    this,
                    Invocation.method(#joinGroupByValue, [], {
                      #enteredValue: enteredValue,
                      #memberID: memberID,
                      #coursesForSchoolClass: coursesForSchoolClass,
                      #version: version,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<dynamic>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<dynamic>> enterActivationCode({
    required String? enteredActivationCode,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#enterActivationCode, [], {
              #enteredActivationCode: enteredActivationCode,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<dynamic>>.value(
              _FakeAppFunctionsResult_0<dynamic>(
                this,
                Invocation.method(#enterActivationCode, [], {
                  #enteredActivationCode: enteredActivationCode,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<dynamic>>.value(
                  _FakeAppFunctionsResult_0<dynamic>(
                    this,
                    Invocation.method(#enterActivationCode, [], {
                      #enteredActivationCode: enteredActivationCode,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<dynamic>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> joinWithGroupId({
    required String? id,
    required String? type,
    required String? uId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#joinWithGroupId, [], {
              #id: id,
              #type: type,
              #uId: uId,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#joinWithGroupId, [], {
                  #id: id,
                  #type: type,
                  #uId: uId,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#joinWithGroupId, [], {
                      #id: id,
                      #type: type,
                      #uId: uId,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> leave({
    required String? id,
    required String? type,
    required String? memberID,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#leave, [], {
              #id: id,
              #type: type,
              #memberID: memberID,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#leave, [], {
                  #id: id,
                  #type: type,
                  #memberID: memberID,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#leave, [], {
                      #id: id,
                      #type: type,
                      #memberID: memberID,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> groupEdit({
    required String? id,
    required String? type,
    required Map<String, dynamic>? data,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#groupEdit, [], {
              #id: id,
              #type: type,
              #data: data,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#groupEdit, [], {
                  #id: id,
                  #type: type,
                  #data: data,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#groupEdit, [], {
                      #id: id,
                      #type: type,
                      #data: data,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> groupEditSettings({
    required String? id,
    required String? type,
    required Map<String, dynamic>? settings,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#groupEditSettings, [], {
              #id: id,
              #type: type,
              #settings: settings,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#groupEditSettings, [], {
                  #id: id,
                  #type: type,
                  #settings: settings,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#groupEditSettings, [], {
                      #id: id,
                      #type: type,
                      #settings: settings,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> groupDelete({
    required String? groupID,
    required String? type,
    String? schoolClassDeleteType,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#groupDelete, [], {
              #groupID: groupID,
              #type: type,
              #schoolClassDeleteType: schoolClassDeleteType,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#groupDelete, [], {
                  #groupID: groupID,
                  #type: type,
                  #schoolClassDeleteType: schoolClassDeleteType,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#groupDelete, [], {
                      #groupID: groupID,
                      #type: type,
                      #schoolClassDeleteType: schoolClassDeleteType,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> groupCreate({
    required String? id,
    required String? memberID,
    required String? type,
    required Map<String, dynamic>? data,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#groupCreate, [], {
              #id: id,
              #memberID: memberID,
              #type: type,
              #data: data,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#groupCreate, [], {
                  #id: id,
                  #memberID: memberID,
                  #type: type,
                  #data: data,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#groupCreate, [], {
                      #id: id,
                      #memberID: memberID,
                      #type: type,
                      #data: data,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> userUpdate({
    required String? userID,
    required Map<String, dynamic>? userData,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#userUpdate, [], {
              #userID: userID,
              #userData: userData,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#userUpdate, [], {
                  #userID: userID,
                  #userData: userData,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#userUpdate, [], {
                      #userID: userID,
                      #userData: userData,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> memberUpdateRole({
    required String? memberID,
    required String? id,
    required String? role,
    required String? type,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#memberUpdateRole, [], {
              #memberID: memberID,
              #id: id,
              #role: role,
              #type: type,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#memberUpdateRole, [], {
                  #memberID: memberID,
                  #id: id,
                  #role: role,
                  #type: type,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#memberUpdateRole, [], {
                      #memberID: memberID,
                      #id: id,
                      #role: role,
                      #type: type,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> userDelete({
    required String? userID,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#userDelete, [], {#userID: userID}),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#userDelete, [], {#userID: userID}),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#userDelete, [], {#userID: userID}),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> schoolClassAddCourse({
    required String? schoolClassID,
    required String? courseID,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#schoolClassAddCourse, [], {
              #schoolClassID: schoolClassID,
              #courseID: courseID,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#schoolClassAddCourse, [], {
                  #schoolClassID: schoolClassID,
                  #courseID: courseID,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#schoolClassAddCourse, [], {
                      #schoolClassID: schoolClassID,
                      #courseID: courseID,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> schoolClassRemoveCourse({
    required String? schoolClassID,
    required String? courseID,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#schoolClassRemoveCourse, [], {
              #schoolClassID: schoolClassID,
              #courseID: courseID,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#schoolClassRemoveCourse, [], {
                  #schoolClassID: schoolClassID,
                  #courseID: courseID,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#schoolClassRemoveCourse, [], {
                      #schoolClassID: schoolClassID,
                      #courseID: courseID,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<bool>> authenticateUserViaQrCodeId({
    required String? uid,
    required String? qrId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#authenticateUserViaQrCodeId, [], {
              #uid: uid,
              #qrId: qrId,
            }),
            returnValue: _i4.Future<_i2.AppFunctionsResult<bool>>.value(
              _FakeAppFunctionsResult_0<bool>(
                this,
                Invocation.method(#authenticateUserViaQrCodeId, [], {
                  #uid: uid,
                  #qrId: qrId,
                }),
              ),
            ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<bool>>.value(
                  _FakeAppFunctionsResult_0<bool>(
                    this,
                    Invocation.method(#authenticateUserViaQrCodeId, [], {
                      #uid: uid,
                      #qrId: qrId,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<bool>>);

  @override
  _i4.Future<_i2.AppFunctionsResult<Map<String, dynamic>>> loadHolidays({
    required String? stateCode,
    required String? year,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#loadHolidays, [], {
              #stateCode: stateCode,
              #year: year,
            }),
            returnValue:
                _i4.Future<_i2.AppFunctionsResult<Map<String, dynamic>>>.value(
                  _FakeAppFunctionsResult_0<Map<String, dynamic>>(
                    this,
                    Invocation.method(#loadHolidays, [], {
                      #stateCode: stateCode,
                      #year: year,
                    }),
                  ),
                ),
            returnValueForMissingStub:
                _i4.Future<_i2.AppFunctionsResult<Map<String, dynamic>>>.value(
                  _FakeAppFunctionsResult_0<Map<String, dynamic>>(
                    this,
                    Invocation.method(#loadHolidays, [], {
                      #stateCode: stateCode,
                      #year: year,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.AppFunctionsResult<Map<String, dynamic>>>);
}
