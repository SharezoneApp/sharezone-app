// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import '../common.dart';

/// Helper method that automatically throws if [Process.exitCode] is non-zero
/// (unsucessfull).
Future<ProcessResult> runProcessSucessfullyOrThrow(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  // ignore: unused_element
  bool? includeParentEnvironment,
  bool? runInShell,
  ProcessStartMode mode = ProcessStartMode.normal,
}) async {
  final displayableCommand = '$executable ${arguments.join(' ')}';

  final result = await runProcess(executable, arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode);
  if (result.exitCode != 0) {
    throw Exception(
        'Process ended with non-zero exit code: $displayableCommand (exit code ${result.exitCode}): ${result.stderr}\n\n stdout:${result.stdout}');
  }

  return ProcessResult(result.pid, exitCode, result.stdout, result.stderr);
}

/// Helper method with automatic (verbose) logging and workarounds for some
/// weird behavior of normal dart:io processes.
Future<ProcessResult> runProcess<T>(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  // ignore: unused_element
  bool? includeParentEnvironment,
  bool? runInShell,
  ProcessStartMode mode = ProcessStartMode.normal,
}) async {
  final displayableCommand = '$executable ${arguments.join(' ')}';
  if (isVerbose) print('Starting $displayableCommand...');

  final process = await Process.start(executable, arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      // Else on Windows some operation might just not work if both are not true
      includeParentEnvironment: includeParentEnvironment ?? true,
      runInShell: runInShell ?? true,
      //
      mode: mode);

  // Somehow (at least on Windows but I think also on other platforms)
  // `await process.exitCode` below doesn't complete if we don't listen to
  // stdout or stderr of the process?!?!?!
  // I don't know why and it's really confusing.
  final broadcastStdout = process.stdout.asBroadcastStream();
  final broadcastStderr = process.stderr.asBroadcastStream();

  // Stream live output if desired
  broadcastStdout.listen(isVerbose ? stdout.add : (_) {});
  broadcastStderr.listen(isVerbose ? stderr.add : (_) {});

  // Buffer output to print if process has error
  // We don't listen until a Stream completes because for some __ reason `dart
  // pub get` doesn't close stderr stream when encountering an error (means that
  // we would wait forever).
  final stdoutBuffer = StringBuffer();
  broadcastStdout.toUtf8().listen(stdoutBuffer.write);
  final stderrBuffer = StringBuffer();
  broadcastStderr.toUtf8().listen(stderrBuffer.write);

  if (isVerbose) print('Waiting for exit code...');
  final exitCode = await process.exitCode;
  if (isVerbose) print('Got exit code $exitCode...');

  final stdoutOutput = stdoutBuffer.toString();
  final stderrOutput = stderrBuffer.toString();

  return ProcessResult(process.pid, exitCode, stdoutOutput, stderrOutput);
}
