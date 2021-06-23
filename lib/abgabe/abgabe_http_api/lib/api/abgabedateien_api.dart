import 'dart:async';
import 'dart:convert';

import 'package:abgabe_http_api/model/dateien_hinzufuegen_command_dto.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

class AbgabedateienApi {
  final Dio _dio;
  Serializers _serializers;

  AbgabedateienApi(this._dio, this._serializers);

  ///
  ///
  ///
  Future<Response> addFiles(
    String submissionId,
    DateienHinzufuegenCommandDto dateienHinzufuegenCommandDto, {
    CancelToken cancelToken,
    Map<String, String> headers,
  }) async {
    String _path = "/v1/submissions/{submissionId}/files/addList"
        .replaceAll("{" r'submissionId' "}", submissionId.toString());

    Map<String, dynamic> queryParams = {};
    Map<String, String> headerParams = Map.from(headers ?? {});
    dynamic bodyData;

    queryParams.removeWhere((key, value) => value == null);
    headerParams.removeWhere((key, value) => value == null);

    List<String> contentTypes = ["application/json"];

    var serializedBody = _serializers.serialize(dateienHinzufuegenCommandDto);
    var jsondateienHinzufuegenCommandDto = json.encode(serializedBody);
    bodyData = jsondateienHinzufuegenCommandDto;

    return _dio.request(
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
