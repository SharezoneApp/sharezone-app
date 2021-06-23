import 'dart:convert';

extension StreamToUtf8String on Stream<List<int>> {
  Future<String> toUtf8String() => transform(utf8.decoder)
      .reduce((previous, element) => '$previous $element');
}
