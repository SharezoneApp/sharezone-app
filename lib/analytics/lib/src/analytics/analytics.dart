import 'package:collection/collection.dart';

// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic>? data;

  const AnalyticsEvent(this.name, {this.data});

  @override
  String toString() {
    return "$runtimeType(name:$name, data: $data)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is AnalyticsEvent &&
        other.name == name &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode => name.hashCode ^ data.hashCode;
}

// ignore: one_member_abstracts
abstract class AnalyticsBackend {
  const AnalyticsBackend();

  void log(String name, [Map<String, dynamic>? data]);

  Future<void> setAnalyticsCollectionEnabled(bool value);
  Future<void> logSignUp({
    required String signUpMethod,
  });
  Future<void> setCurrentScreen({
    required String screenName,
  });
  Future<void> setUserProperty({required String name, required String value});
}

class Analytics {
  final AnalyticsBackend _backend;

  const Analytics(this._backend);

  void log(AnalyticsEvent event) {
    if (event.name.isNotEmpty) {
      _backend.log(event.name, event.data ?? {});
    }
  }

  void setAnalyticsCollectionEnabled(bool value) {
    _backend.setAnalyticsCollectionEnabled(value);
  }

  Future<void> logSignUp({
    required String signUpMethod,
  }) {
    return _backend.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> setCurrentScreen({
    required String screenName,
  }) {
    return _backend.setCurrentScreen(screenName: screenName);
  }

  Future<void> setUserProperty({required String name, required String value}) =>
      _backend.setUserProperty(name: name, value: value);
}
