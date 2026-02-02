// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io' as io;

import 'package:clock/clock.dart';
import 'package:file/file.dart' as file;
import 'package:path/path.dart' as path;
import 'package:process_runner/process_runner.dart';
import 'package:sz_repo_cli/src/common/common.dart';

/// Run a task via [runTaskForPackage] for many [Package] concurrently.
abstract class ConcurrentCommand extends CommandBase {
  ConcurrentCommand(super.context) {
    argParser
      ..addOption(
        'only',
        help:
            'Only run the task for the given package(s). Package names can be separated by comma. E.g. `--only package1` or `--only=package1,package2`.',
      )
      ..addOption(
        'exclude',
        help:
            'Exclude the given package(s) from the task. Package names can be separated by comma. E.g. `--exclude package1` or `--exclude=package1,package2`.',
      )
      ..addConcurrencyOption(defaultMaxConcurrency: defaultMaxConcurrency)
      ..addPackageTimeoutOption(
        defaultInMinutes: defaultPackageTimeout.inMinutes,
      );
  }

  /// How long the task can run per package before being considered as failed.
  ///
  /// If [runTaskForPackage] takes longer than [defaultPackageTimeout] then the
  /// task for the package that exceeded the timeout will be marked as failing.
  ///
  /// This can be overridden by the user via command line argument.
  Duration get defaultPackageTimeout => const Duration(minutes: 10);

  /// Number of packages that are going to be processed concurrently.
  ///
  /// Setting this to <= 0 means that there is no concurrency limit, i.e.
  /// everything will be processed at once.
  ///
  /// This can be overridden by the user via command line argument.
  int get defaultMaxConcurrency => 5;

  /// Used to run setup steps before [runTaskForPackage] is called.
  ///
  /// For example this method might be used to activate a package (`pub global
  /// activate`) that is gonna be used in [runTaskForPackage].
  Future<void> runSetup() async {
    return;
  }

  /// Whether to run each package task inside a dedicated git worktree.
  ///
  /// This avoids Flutter command contention between packages, but should only
  /// be enabled for commands that do not need to modify the main working tree.
  bool get useGitWorktrees => false;

  /// The Task to run for each [Package].
  ///
  /// If e.g. the Command is used to test all packages in the repo then one
  /// might use this method to call `flutter test` for [package].
  Future<void> runTaskForPackage(Package package);

  /// Stream of packages for which [runTaskForPackage] will be called.
  ///
  /// Can be overridden to e.g. add a filter (`.where((package) =>
  /// package.hasTestDirectory`).
  Stream<Package> get packagesToProcess {
    var stream = repo.streamPackages();

    final onlyPackageNames = _parseCommaSeparatedList('only');
    if (onlyPackageNames.isNotEmpty) {
      stream = stream.where(
        (package) => onlyPackageNames.contains(package.name),
      );
    }

    final excludePackageNames = _parseCommaSeparatedList('exclude');
    if (excludePackageNames.isNotEmpty) {
      stream = stream.where(
        (package) => !excludePackageNames.contains(package.name),
      );
    }

    return stream;
  }

  List<String> _parseCommaSeparatedList(String optionName) {
    final onlyArg = argResults![optionName] as String?;
    if (onlyArg == null) {
      return [];
    }
    return onlyArg.split(',');
  }

  @override
  Future<void> run() async {
    isVerbose = argResults!['verbose'] ?? false;
    await runSetup();

    final max = argResults![maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently =
        max != null
            ? int.tryParse(argResults![maxConcurrentPackagesOptionName])
            // null as interpreted as "no concurrency limit" (everything at once).
            : null;

    final taskRunner = ConcurrentPackageTaskRunner(
      getCurrentDateTime: () => clock.now(),
    );

    GitWorktreeManager? worktreeManager;
    if (useGitWorktrees) {
      final manager = GitWorktreeManager(
        repo: repo,
        processRunner: processRunner,
        fileSystem: fileSystem,
      );
      final canUseWorktrees = await manager.canUseWorktrees();
      if (canUseWorktrees) {
        await manager.ensureRepoFlutterSdkInstalled();
        worktreeManager = manager;
      }
    }

    final res =
        taskRunner
            .runTaskForPackages(
              packageStream: packagesToProcess,
              runTask: (package) async {
                if (worktreeManager == null) {
                  return runTaskForPackage(package);
                }
                return worktreeManager.runInWorktree(
                  package,
                  runTaskForPackage,
                );
              },
              maxNumberOfPackagesBeingProcessedConcurrently:
                  maxNumberOfPackagesBeingProcessedConcurrently,
              perPackageTaskTimeout: argResults!.packageTimeoutDuration,
            )
            .asBroadcastStream();

    final presenter = PackageTasksStatusPresenter();
    presenter.continuouslyPrintTaskStatusUpdatesToConsole(res);

    final failures = await res.allFailures;

    if (failures.isNotEmpty) {
      io.stderr.writeln('There were failures. See above for more information.');
      await presenter.printFailedTasksSummary(failures);
      io.exit(1);
    } else {
      io.stdout.writeln('Task was successfully executed for all packages!');
      io.exit(0);
    }
  }
}

class GitWorktreeManager {
  GitWorktreeManager({
    required this.repo,
    required this.processRunner,
    required this.fileSystem,
  }) {
    _worktreesRoot = fileSystem.directory(
      path.join(io.Directory.systemTemp.path, 'sz_repo_cli_worktrees'),
    );
  }

  final SharezoneRepo repo;
  final ProcessRunner processRunner;
  final file.FileSystem fileSystem;
  late final file.Directory _worktreesRoot;

  Future<bool> canUseWorktrees() async {
    final changes = await hasGitChanges(processRunner, repo.location);
    if (changes.hasChanges) {
      io.stderr.writeln(
        '⚠️  Skipping worktrees because the repo has uncommitted changes.\n'
        '    Commit or stash changes to enable worktree-based concurrency.',
      );
      return false;
    }
    return true;
  }

  Future<void> ensureRepoFlutterSdkInstalled() async {
    final flutterSdkDir = repo.location
        .childDirectory('.fvm')
        .childDirectory('flutter_sdk');
    if (!flutterSdkDir.existsSync()) {
      await processRunner.runCommand([
        'fvm',
        'install',
      ], workingDirectory: repo.location);
    }
  }

  Future<void> runInWorktree(
    Package package,
    Future<void> Function(Package package) runTaskForPackage,
  ) async {
    await _worktreesRoot.create(recursive: true);

    final worktreePath = path.join(
      _worktreesRoot.path,
      '${package.name}-${DateTime.now().microsecondsSinceEpoch}-${io.pid}',
    );

    await processRunner.runCommand([
      'git',
      'worktree',
      'add',
      '--detach',
      worktreePath,
    ], workingDirectory: repo.location);

    final worktreeRoot = fileSystem.directory(worktreePath);
    try {
      await _ensureWorktreeFlutterSdk(worktreeRoot);

      final relativePackagePath = path.relative(
        package.location.path,
        from: repo.location.path,
      );
      final worktreePackageDir = worktreeRoot.childDirectory(
        relativePackagePath,
      );
      final worktreePackage = Package.fromDirectory(worktreePackageDir);
      await runTaskForPackage(worktreePackage);
    } finally {
      try {
        await processRunner.runCommand(
          ['git', 'worktree', 'remove', '--force', worktreePath],
          workingDirectory: repo.location,
          failOk: true,
        );
      } catch (e) {
        io.stderr.writeln('⚠️  Failed to remove worktree $worktreePath: $e');
      }
    }
  }

  Future<void> _ensureWorktreeFlutterSdk(file.Directory worktreeRoot) async {
    final worktreeFvmDir = worktreeRoot.childDirectory('.fvm');
    final worktreeFlutterSdk = worktreeFvmDir.childDirectory('flutter_sdk');
    if (worktreeFlutterSdk.existsSync()) {
      return;
    }

    final repoFlutterSdk = repo.location
        .childDirectory('.fvm')
        .childDirectory('flutter_sdk');
    if (repoFlutterSdk.existsSync()) {
      await worktreeFvmDir.create(recursive: true);
      try {
        io.Link(
          worktreeFlutterSdk.path,
        ).createSync(repoFlutterSdk.path, recursive: true);
        return;
      } catch (_) {
        // Fall back to `fvm install` if linking fails.
      }
    }

    await processRunner.runCommand([
      'fvm',
      'install',
    ], workingDirectory: worktreeRoot);
  }
}
