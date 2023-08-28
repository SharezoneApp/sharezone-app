// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: always_declare_return_types
// ignore_for_file: prefer_generic_function_type_aliases
// ignore_for_file: invalid_assignment

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  get localeName => 'de';

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        // ignore: map_value_type_not_assignable
        "Feddig": MessageLookupByLibrary.simpleMessage("Feddig"),
        // ignore: map_value_type_not_assignable
        "Offen": MessageLookupByLibrary.simpleMessage("Offen")
      };
}
