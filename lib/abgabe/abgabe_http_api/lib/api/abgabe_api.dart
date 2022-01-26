// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:abgabe_http_api/model/submission_dto.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

class AbgabeApi {
  final Dio _dio;
  Serializers _serializers;

  AbgabeApi(this._dio, this._serializers);

  ///
  ///
  ///
  Future<Response> publishSubmission(
    String id,
    SubmissionDto submissionDto, {
    CancelToken cancelToken,
    Map<String, String> headers,
  }) async {
    String _path =
        "/v1/submissions/{id}".replaceAll("{" r'id' "}", id.toString());

    Map<String, dynamic> queryParams = {};
    Map<String, String> headerParams = Map.from(headers ?? {});
    dynamic bodyData;

    queryParams.removeWhere((key, value) => value == null);
    headerParams.removeWhere((key, value) => value == null);

    List<String> contentTypes = ["application/json"];

    var serializedBody = _serializers.serialize(submissionDto);
    var jsonsubmissionDto = json.encode(serializedBody);
    bodyData = jsonsubmissionDto;

    return _dio.request(
      _path,
      queryParameters: queryParams,
      data: bodyData,
      options: Options(
        method: 'patch'.toUpperCase(),
        headers: headerParams,
        contentType:
            contentTypes.isNotEmpty ? contentTypes[0] : "application/json",
      ),
      cancelToken: cancelToken,
    );
  }
}
