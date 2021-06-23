import 'package:app_functions/exceptions.dart';
import 'package:app_functions/src/app_functions_result.dart';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class AppFunctions {
  final FirebaseFunctions _firebaseFunctions;

  AppFunctions(this._firebaseFunctions);

  Future<AppFunctionsResult<T>> callCloudFunction<T>(
      {@required String functionName,
      @required Map<String, dynamic> parameters}) async {
    try {
      final httpsCallableResult =
          await _firebaseFunctions.httpsCallable(functionName).call(parameters);
      return AppFunctionsResult<T>.data(httpsCallableResult.data);
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        final PlatformException platformException = e;
        return AppFunctionsResult.exception(
            _mapPlatformExceptionToAppFunctionsException(platformException));
      }
      if (e is FirebaseFunctionsException) {
        final FirebaseFunctionsException cloudFunctionsException = e;
        return AppFunctionsResult.exception(
            _mapFirebaseFunctionsExceptionToAppFunctionsException(
                cloudFunctionsException));
      }
      return AppFunctionsResult.exception(UnknownAppFunctionsException(e));
    }
  }

  AppFunctionsException _mapFirebaseFunctionsExceptionToAppFunctionsException(
      FirebaseFunctionsException cloudFunctionsException) {
    print("Code: " + cloudFunctionsException.code);
    print("Details: " + cloudFunctionsException.details);
    print("Message: " + cloudFunctionsException.message);
    if (cloudFunctionsException.code == 'DeadlineExceeded')
      return TimeoutAppFunctionsException();

    return UnknownAppFunctionsException(cloudFunctionsException);
  }

  AppFunctionsException _mapPlatformExceptionToAppFunctionsException(
      PlatformException platformException) {
    if (platformException.code == '-1009')
      return NoInternetAppFunctionsException();
    print("Code: " + platformException.code);
    print("Message: " + platformException.message);

    return UnknownAppFunctionsException(platformException);
  }
}
