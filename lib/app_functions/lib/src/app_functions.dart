// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:app_functions/exceptions.dart';
import 'package:app_functions/src/app_functions_result.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

class AppFunctions {
  final FirebaseFunctions _firebaseFunctions;

  AppFunctions(this._firebaseFunctions);

  Future<AppFunctionsResult<T>> callCloudFunction<T>({
    required String functionName,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final httpsCallableResult =
          await _firebaseFunctions.httpsCallable(functionName).call(parameters);
      return AppFunctionsResult<T>.data(httpsCallableResult.data);
    } catch (e, s) {
      log('Can not resolve callable cloud function', error: e, stackTrace: s);
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
    log("Code: ${cloudFunctionsException.code}");
    log("Details: ${cloudFunctionsException.details}");
    log("Message: ${cloudFunctionsException.message}");
    if (cloudFunctionsException.code == 'DeadlineExceeded') {
      return TimeoutAppFunctionsException();
    }

    return UnknownAppFunctionsException(cloudFunctionsException);
  }

  AppFunctionsException _mapPlatformExceptionToAppFunctionsException(
      PlatformException platformException) {
    if (platformException.code == '-1009') {
      return NoInternetAppFunctionsException();
    }
    log("Code: ${platformException.code}");
    log("Message: ${platformException.message}");

    return UnknownAppFunctionsException(platformException);
  }
}
