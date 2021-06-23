import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('user', () async {
    const link =
        "https://europe-west1-sharezone-c2bd8.cloudfunctions.net/laMetricTimeNumberOfUsers";
    final response = await Dio()
        .get(kIsWeb ? "https://cors-anywhere.herokuapp.com/$link" : link);
    final counter = response.data["frames"].first["text"].toString();
    final prints = "${counter.substring(0, 3)}.${counter.substring(3, 6)}";
    print(prints);
  });
}
