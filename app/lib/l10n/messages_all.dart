// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// ignore_for_file: implementation_imports
// ignore_for_file: prefer_generic_function_type_aliases
// ignore_for_file: unused_element

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

import 'messages_de.dart' as messages_de;
import 'messages_en.dart' as messages_en;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'de': () => Future.value(null),
  'en': () => Future.value(null),
};

MessageLookupByLibrary _findExact(String localeName) {
  switch (localeName) {
    case 'de':
      return messages_de.messages;
    case 'en':
      return messages_en.messages;
    default:
      return null;
  }
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(String locale) {
  final actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
