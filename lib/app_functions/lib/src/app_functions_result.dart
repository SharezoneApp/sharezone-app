// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'app_functions_exceptions.dart';

/// Das Result Objekt nach Aufruf einer AppFunction.
/// Es enthält entweder Daten oder eine [AppFunctionsException].
/// Über hasData oder hasException kann dies ermittelt werden.
class AppFunctionsResult<T> {
  final T data;
  final AppFunctionsException exception;
  final bool hasData, hasException;

  AppFunctionsResult._(
      {@required this.data,
      @required this.exception,
      @required this.hasData,
      @required this.hasException});

  factory AppFunctionsResult.data(T data) {
    return AppFunctionsResult._(
      data: data,
      hasData: true,
      exception: null,
      hasException: false,
    );
  }

  factory AppFunctionsResult.exception(
      AppFunctionsException appFunctionsException) {
    return AppFunctionsResult._(
      data: null,
      hasData: false,
      exception: appFunctionsException,
      hasException: true,
    );
  }
}
