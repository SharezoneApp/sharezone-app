// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:convert';
import 'dart:io';

import 'package:file/file.dart' as file;
import 'package:process/process.dart';
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

extension ProcessRunnerCopyWith on ProcessRunner {
  ProcessRunner copyWith({
    Directory? defaultWorkingDirectory,
    ProcessManager? processManager,
    Map<String, String>? environment,
    bool? includeParentEnvironment,
    bool? printOutputDefault,
    Encoding? decoder,
  }) {
    return ProcessRunner(
      defaultWorkingDirectory:
          defaultWorkingDirectory ?? this.defaultWorkingDirectory,
      processManager: processManager ?? this.processManager,
      environment: environment ?? this.environment,
      includeParentEnvironment:
          includeParentEnvironment ?? this.includeParentEnvironment,
      printOutputDefault: printOutputDefault ?? this.printOutputDefault,
      decoder: decoder ?? this.decoder,
    );
  }
}

extension RunProcessCustom on ProcessRunner {
  /// Wraps [ProcessRunner.runProcess] and customizes args and behavior.
  ///
  /// Modifications:
  /// * Add [addedEnvironment] parameter, which will be added to
  ///   [ProcessRunner.environment].
  /// * Set [printOutput] to true if [isVerbose] is true.
  ///   If [printOutput] is passed, it overrides [isVerbose].
  ///   If [printOutput] is `null` and [isVerbose] is false, [printOutput] will
  ///   be `null` which means it will use [ProcessRunner.printOutputDefault].
  ///
  /// Run the command and arguments in `commandLine` as a sub-process from
  /// `workingDirectory` if set, or the [defaultWorkingDirectory] if not. Uses
  /// [Directory.current] if [defaultWorkingDirectory] is not set.
  ///
  /// Set `failOk` if [runProcess] should not throw an exception when the
  /// command completes with a a non-zero exit code.
  ///
  /// If `printOutput` is set, indicates that the command will both write the
  /// output to stdout/stderr, as well as return it in the
  /// [ProcessRunnerResult.stderr], [ProcessRunnerResult.stderr] members of the
  /// result. This overrides the setting of [printOutputDefault].
  ///
  /// The `printOutput` argument defaults to the value of [printOutputDefault].
  Future<ProcessRunnerResult> run(
    List<String> commandLine, {
    file.Directory? workingDirectory,
    bool? printOutput,
    bool failOk = false,
    Stream<List<int>>? stdin,
    bool runInShell = false,
    ProcessStartMode startMode = ProcessStartMode.normal,
    Map<String, String> addedEnvironment = const {},
  }) async {
    final environment = this.environment;
    environment.addAll(addedEnvironment);
    final runner = copyWith(environment: environment);

    Directory? workingDir;
    if (workingDirectory != null) {
      workingDir = Directory(workingDirectory.path);
    }

    return runner.runProcess(
      commandLine,
      workingDirectory: workingDir,
      printOutput: printOutput ??= isVerbose ? true : null,
      failOk: failOk,
      stdin: stdin,
      runInShell: runInShell,
      startMode: startMode,
    );
  }
}
