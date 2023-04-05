// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library abgabe_http_api.api;

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:abgabe_http_api/serializers.dart';
import 'package:abgabe_http_api/api/abgabe_api.dart';
import 'package:abgabe_http_api/api/abgabedatei_api.dart';
import 'package:abgabe_http_api/api/abgabedateien_api.dart';


class AbgabeHttpApi {
    late Dio dio;
    late Serializers serializers;
    String basePath = "https://api.sharezone.net";

    AbgabeHttpApi({Dio? dio, Serializers? serializers}) {
    this.dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: basePath,
            connectTimeout: 5000,
            receiveTimeout: 3000,
          ),
        );
    this.serializers = serializers ?? standardSerializers;
}


    /**
    * Get AbgabeApi instance, base route and serializer can be overridden by a given but be careful,
    * by doing that all interceptors will not be executed
    */
    AbgabeApi getAbgabeApi() {
    return AbgabeApi(dio, serializers);
    }


    /**
    * Get AbgabedateiApi instance, base route and serializer can be overridden by a given but be careful,
    * by doing that all interceptors will not be executed
    */
    AbgabedateiApi getAbgabedateiApi() {
    return AbgabedateiApi(dio, serializers);
    }


    /**
    * Get AbgabedateienApi instance, base route and serializer can be overridden by a given but be careful,
    * by doing that all interceptors will not be executed
    */
    AbgabedateienApi getAbgabedateienApi() {
    return AbgabedateienApi(dio, serializers);
    }


}
