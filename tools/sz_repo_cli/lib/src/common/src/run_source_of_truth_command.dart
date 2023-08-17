// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:sz_repo_cli/src/common/src/run_process.dart';
import 'package:sz_repo_cli/src/common/src/sharezone_repo.dart';
import 'package:yaml/yaml.dart';

/// Run a license header command via a key.
///
/// The key can be seen in the [repo.commandsSourceOfTruthYamlFile] file.
Future<ProcessResult> runSourceOfTruthCommand({
  required String commandKey,
  required SharezoneRepo repo,

  /// Arguments that will be append to the arguments of the command.
  List<String> argumentsToAppend = const [],
}) {
  final sot = repo.commandsSourceOfTruthYamlFile;
  final commands = loadYaml(sot.readAsStringSync()) as Map;
  final command = commands[commandKey] as String;
  final splitted = command.split(' ');
  final executable = splitted[0];
  var argumentsString = command.replaceFirst('$executable ', '');
  final arguments = _convertIntoArgumentsList(argumentsString)
    ..addAll(argumentsToAppend);

  return runProcess(
    executable,
    arguments,
    workingDirectory: repo.location.path,
  );
}

/// Converts command line arguments into a List<String>.
///
/// The methods to run commands via [Process] expect a single "command string"
/// (e.g. `addlicense`) and a List<String> for arguments (example below).
///
/// If we read a command String from somewhere else we will need to split this
/// string into its arguments via this method.
///
/// Input: -check -c "Sharezone UG (haftungsbeschränkt)" -f header_template.txt -ignore "**/GeneratedPluginRegistrant.swift" -ignore "**/**.g.dart"
/// Output: [-check, -c, Sharezone UG (haftungsbeschränkt), -f, header_template.txt, -ignore, **/GeneratedPluginRegistrant.swift, -ignore, **/**.g.dart]
List<String> _convertIntoArgumentsList(String input) {
  final result = <String>[];

  var current = '';

  String? quoteToken;
  var wasLastTokenQuoted = false;

  for (var index = 0; index < input.length; index++) {
    final token = input[index];

    if (quoteToken != null) {
      if (token == quoteToken) {
        wasLastTokenQuoted = true;
        quoteToken = null;
      } else {
        current += token;
      }
    } else {
      switch (token) {
        case "'":
        case '"':
          quoteToken = token;
          continue;

        case ' ':
          if (wasLastTokenQuoted || current.isNotEmpty) {
            result.add(current);
            current = '';
          }
          break;

        default:
          current += token;
          wasLastTokenQuoted = false;
      }
    }
  }

  if (wasLastTokenQuoted || current.isNotEmpty) {
    result.add(current);
  }

  if (quoteToken != null) {
    throw Exception('Unbalanced quote $quoteToken in input:\n$input');
  }

  return result;
}
