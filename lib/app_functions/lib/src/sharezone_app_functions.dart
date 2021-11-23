import 'package:app_functions/app_functions.dart';
import 'package:meta/meta.dart';

class SharezoneAppFunctions {
  final AppFunctions _appFunctions;

  SharezoneAppFunctions(this._appFunctions);

  Future<AppFunctionsResult<dynamic>> joinGroupByValue({
    @required String enteredValue,
    @required String memberID,
    List<String> coursesForSchoolClass,
    int version = 2,
  }) {
    return _appFunctions
        .callCloudFunction(functionName: 'JoinGroupByValue', parameters: {
      'value': enteredValue,
      'courseList': coursesForSchoolClass,
      'memberID': memberID,
      'version': version,
    });
  }

  Future<AppFunctionsResult<dynamic>> enterActivationCode(
      {@required String enteredActivationCode}) {
    return _appFunctions
        .callCloudFunction(functionName: 'EnterActivationCode', parameters: {
      'activationCodeID': enteredActivationCode,
    });
  }

  /// Beitreten einer Gruppe mittels einer Id. Dies ist zum Beispiel beim Beitreten eines
  /// Kurses in einer Klasse der Fall.
  Future<AppFunctionsResult<bool>> joinWithGroupId({
    @required String id,
    @required String type,
    @required String uId,
  }) {
    return _appFunctions
        .callCloudFunction(functionName: 'JoinWithGroupId', parameters: {
      'id': id,
      'type': type,
      'uId': uId,
    });
  }

  Future<AppFunctionsResult<bool>> leave(
      {@required String id, @required String type, @required String memberID}) {
    return _appFunctions.callCloudFunction(functionName: 'Leave', parameters: {
      'id': id,
      'type': type,
      'memberID': memberID,
    });
  }

  Future<AppFunctionsResult<bool>> groupEdit(
      {@required String id,
      @required String type,
      @required Map<String, dynamic> data}) {
    return _appFunctions
        .callCloudFunction(functionName: 'GroupEdit', parameters: {
      'id': id,
      'data': data,
      'type': type,
    });
  }

  Future<AppFunctionsResult<bool>> groupEditSettings(
      {@required String id,
      @required String type,
      @required Map<String, dynamic> settings}) {
    return _appFunctions
        .callCloudFunction(functionName: 'GroupEditSettings', parameters: {
      'id': id,
      'settings': settings,
      'type': type,
    });
  }

  Future<AppFunctionsResult<bool>> generateNewMeetingID(
      {@required String id, @required String type}) {
    return _appFunctions.callCloudFunction(
        functionName: 'GenerateNewGroupMeetingID',
        parameters: {
          'id': id,
          'type': type,
        });
  }

  Future<AppFunctionsResult<bool>> groupDelete(
      {@required String groupID,
      @required String type,
      String schoolClassDeleteType}) {
    return _appFunctions
        .callCloudFunction(functionName: 'GroupDelete', parameters: {
      'id': groupID,
      'schoolClassDeleteType': schoolClassDeleteType,
      'type': type,
    });
  }

  Future<AppFunctionsResult<bool>> groupCreate(
      {@required String id,
      @required String memberID,
      @required String type,
      @required Map<String, dynamic> data}) {
    return _appFunctions
        .callCloudFunction(functionName: 'GroupCreate', parameters: {
      'memberID': memberID,
      'id': id,
      'data': data,
      'type': type,
    });
  }

  Future<AppFunctionsResult<bool>> userUpdate(
      {@required String userID, @required Map<String, dynamic> userData}) {
    return _appFunctions
        .callCloudFunction(functionName: 'UserUpdate', parameters: {
      'userID': userID,
      'userData': userData,
    });
  }

  Future<AppFunctionsResult<bool>> memberUpdateRole(
      {@required String memberID,
      @required String id,
      @required String role,
      @required String type}) {
    return _appFunctions
        .callCloudFunction(functionName: 'MemberUpdateRole', parameters: {
      'memberID': memberID,
      'id': id,
      'role': role,
      'type': type,
    });
  }

  Future<AppFunctionsResult<bool>> userDelete({@required String userID}) {
    return _appFunctions
        .callCloudFunction(functionName: 'UserDelete', parameters: {
      'userID': userID,
    });
  }

  Future<AppFunctionsResult<bool>> schoolClassAddCourse(
      {@required String schoolClassID, @required String courseID}) {
    return _appFunctions
        .callCloudFunction(functionName: 'SchoolClassAddCourse', parameters: {
      'schoolClassID': schoolClassID,
      'courseID': courseID,
    });
  }

  Future<AppFunctionsResult<bool>> schoolClassRemoveCourse(
      {@required String schoolClassID, @required String courseID}) {
    return _appFunctions
        .callCloudFunction(functionName: 'SchoolClassAddCourse', parameters: {
      'schoolClassID': schoolClassID,
      'courseID': courseID,
    });
  }

  Future<AppFunctionsResult<bool>> authenticateUserViaQrCodeId(
      {@required String uid, @required String qrId}) async {
    return _appFunctions
        .callCloudFunction(functionName: 'QrCodeSignInAssignUID', parameters: {
      'qrID': qrId,
      'uid': uid,
    });
  }

  Future<AppFunctionsResult<Map<String, dynamic>>> loadHolidays(
      {@required String stateCode, @required String year}) {
    return _appFunctions
        .callCloudFunction(functionName: 'loadHolidays', parameters: {
      'stateCode': stateCode,
      'year': year,
    });
  }
}
