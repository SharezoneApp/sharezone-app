// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:abgabe_http_api/model/datei_hinzufuegen_command_dto.dart';
import 'package:abgabe_http_api/model/dateiname_dto.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

class AbgabedateiApi {
  final Dio _dio;
  final Serializers _serializers;

  AbgabedateiApi(this._dio, this._serializers);

  ///
  ///
  ///
  Future<Response> addFile(
    String submissionId,
    DateiHinzufuegenCommandDto dateiHinzufuegenCommandDto, {
    CancelToken? cancelToken,
    Map<String, String?>? headers,
  }) async {
    String _path = "/v1/submissions/{submissionId}/files"
        .replaceAll("{" r'submissionId' "}", submissionId.toString());

    Map<String, dynamic> queryParams = {};
    Map<String, String> headerParams = Map.from(headers ?? {});
    dynamic bodyData;

    queryParams.removeWhere((key, value) => value == null);
    headerParams.removeWhere((key, value) => value == null);

    List<String> contentTypes = ["application/json"];

    var serializedBody = _serializers.serialize(dateiHinzufuegenCommandDto);
    var jsondateiHinzufuegenCommandDto = json.encode(serializedBody);
    bodyData = jsondateiHinzufuegenCommandDto;

    return _dio!.request(
      _path,
      queryParameters: queryParams,
      data: bodyData,
      options: Options(
        method: 'post'.toUpperCase(),
        headers: headerParams,
        contentType:
            contentTypes.isNotEmpty ? contentTypes[0] : "application/json",
      ),
      cancelToken: cancelToken,
    );
  }

  ///
  ///
  ///
  Future<Response> deleteFile(
    String submissionId,
    String fileId, {
    CancelToken? cancelToken,
    Map<String, String>? headers,
  }) async {
    String _path = "/v1/submissions/{submissionId}/files/{fileId}"
        .replaceAll("{" r'submissionId' "}", submissionId.toString())
        .replaceAll("{" r'fileId' "}", fileId.toString());

    Map<String, dynamic> queryParams = {};
    Map<String, String> headerParams = Map.from(headers ?? {});
    dynamic bodyData;

    queryParams.removeWhere((key, value) => value == null);
    headerParams.removeWhere((key, value) => value == null);

    List<String> contentTypes = [];

    return _dio!.request(
      _path,
      queryParameters: queryParams,
      data: bodyData,
      options: Options(
        method: 'delete'.toUpperCase(),
        headers: headerParams,
        contentType:
            contentTypes.isNotEmpty ? contentTypes[0] : "application/json",
      ),
      cancelToken: cancelToken,
    );
  }

  ///
  ///
  ///
  Future<Response> renameFile(
    String submissionId,
    String fileId,
    DateinameDto dateinameDto, {
    CancelToken? cancelToken,
    Map<String, String>? headers,
  }) async {
    String _path = "/v1/submissions/{submissionId}/files/{fileId}"
        .replaceAll("{" r'submissionId' "}", submissionId.toString())
        .replaceAll("{" r'fileId' "}", fileId.toString());

    Map<String, dynamic> queryParams = {};
    Map<String, String> headerParams = Map.from(headers ?? {});
    dynamic bodyData;

    queryParams.removeWhere((key, value) => value == null);
    headerParams.removeWhere((key, value) => value == null);

    List<String> contentTypes = ["application/json"];

    var serializedBody = _serializers!.serialize(dateinameDto);
    var jsondateinameDto = json.encode(serializedBody);
    bodyData = jsondateinameDto;

    return _dio!.request(
      _path,
      queryParameters: queryParams,
      data: bodyData,
      options: Options(
        method: 'post'.toUpperCase(),
        headers: headerParams,
        contentType:
            contentTypes.isNotEmpty ? contentTypes[0] : "application/json",
      ),
      cancelToken: cancelToken,
    );
  }
}
