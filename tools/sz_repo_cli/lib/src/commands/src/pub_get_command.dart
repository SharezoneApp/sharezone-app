// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sz_repo_cli/src/common/common.dart';

class PubGetCommand extends Command {
  PubGetCommand(this.repo) {
    argParser
      ..addVerboseFlag()
      ..addConcurrencyOption(defaultMaxConcurrency: 8)
      ..addPackageTimeoutOption(defaultInMinutes: 5);
  }

  final SharezoneRepo repo;

  @override
  String get description =>
      'Runs pub get / flutter pub get for all packages under /lib and /app (can be specified)';

  @override
  String get name => 'get';

  @override
  Future<void> run() async {
    isVerbose = argResults['verbose'] ?? false;

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null as interpreted as "no conucrrency limit" (everything at once).
        : null;

    final taskRunner = ConcurrentPackageTaskRunner(
      getCurrentDateTime: () => DateTime.now(),
    );

    final res = taskRunner
        .runTaskForPackages(
          packageStream: repo
              .streamPackages()
              .where((package) => package.hasTestDirectory),
          runTask: (package) => package.getPackages(),
          maxNumberOfPackagesBeingProcessedConcurrently:
              maxNumberOfPackagesBeingProcessedConcurrently,
          perPackageTaskTimeout: argResults.packageTimeoutDuration,
        )
        .asBroadcastStream();

    final presenter = PackageTasksStatusPresenter();
    presenter.continuouslyPrintTaskStatusUpdatesToConsole(res);

    final failures = await res.allFailures;

    if (failures.isNotEmpty) {
      print('There were failures. See above for more information.');
      await presenter.printFailedTasksSummary(failures);
      exit(1);
    } else {
      print('Ran "pub get" for all packages successfully!');
      exit(0);
    }
  }
}

class GetPackagesUseCase {
  final SharezoneRepo repo;
  Duration packageTimeout;
  DateTime Function() _getCurrentDateTime;

  GetPackagesUseCase({
    @required this.repo,
    DateTime Function() getCurrentDateTime,
  }) {
    _getCurrentDateTime = getCurrentDateTime ?? () => DateTime.now();
  }

  Stream<PackageGetResult> getPackages({
    bool includeFlutterApp,
    @required Duration packageTimeout,
  }) {
    this.packageTimeout = packageTimeout;
    var packageStream = repo.dartLibraries.streamPackages().mergeWithValues([
      repo.sharezoneCiCdTool,
      if (includeFlutterApp) repo.sharezoneFlutterApp,
    ]);
    return _getPackages(packageStream);
  }

  PackageStatusUpdater _getStatusUpdater(Package package) =>
      PackageStatusUpdater(
          package: package, getCurrentDateTime: _getCurrentDateTime);

  Stream<PackageGetResult> _getPackages(Stream<Package> packageStream) async* {
    final futures = <Future>[];

    await for (final package in packageStream) {
      final _statusUpdater = _getStatusUpdater(package);
      yield PackageGetResult(package, _statusUpdater.statusStream);

      _statusUpdater.started();
      final future = package
          .getPackages()
          .timeout(
            packageTimeout,
            onTimeout: () =>
                throw PackageTimeoutException(packageTimeout, package),
          )
          .then((_) => _statusUpdater.success())
          .catchError(
              (e, s) => _statusUpdater.failure(error: e, stackTrace: s));

      futures.add(future);
    }

    await Future.wait(futures);
    return;
  }
}

class PackageStatusUpdater {
  final Package package;
  final DateTime Function() getCurrentDateTime;
  final _controller = BehaviorSubject<PackageGetStatus>();
  Stream<PackageGetStatus> get statusStream => _controller;
  Running _running;

  PackageStatusUpdater({
    @required this.package,
    this.getCurrentDateTime,
  });

  void started() {
    _running = Running.since(startedOn: getCurrentDateTime());
    _controller.add(_running);
  }

  void success() {
    if (_running == null) {
      throw StateError('success can only be called after calling running');
    }
    _controller.add(_running.toSuccess(now: getCurrentDateTime()));
    _controller.close();
  }

  void failure({@required dynamic error, StackTrace stackTrace}) {
    if (_running == null) {
      throw StateError('failure can only be called after calling running');
    }
    _controller.add(_running.toFailure(
      error: error,
      stackTrace: stackTrace,
      now: getCurrentDateTime(),
    ));
    _controller.close();
  }
}

class PackageGetResult {
  final Package package;
  final Stream<PackageGetStatus> status;

  PackageGetResult(this.package, this.status);
}

abstract class PackageGetStatus {
  final DateTime startedOn;

  PackageGetStatus({@required this.startedOn});

  FutureOr<T> when<T>({
    @required FutureOr<T> Function(Success) success,
    @required FutureOr<T> Function(Failure) failure,
    @required FutureOr<T> Function(Running) running,
  }) {
    if (this is Success) {
      return success(this as Success);
    }
    if (this is Failure) {
      return failure(this as Failure);
    }
    if (this is Running) {
      return running(this as Running);
    }
    throw UnimplementedError('when not implemented for $runtimeType');
  }
}

class Success extends PackageGetStatus {
  final Duration timeItTookToRun;

  Success({
    @required DateTime startedOn,
    @required this.timeItTookToRun,
  }) : super(startedOn: startedOn);
}

class Failure extends PackageGetStatus {
  final dynamic error;
  final Optional<StackTrace> stackTrace;

  Failure({
    @required this.error,
    StackTrace stackTrace,
    @required DateTime startedOn,
  })  : stackTrace = Optional.ofNullable(stackTrace),
        super(startedOn: startedOn);
}

class Running extends PackageGetStatus {
  Running.since({
    @required DateTime startedOn,
  }) : super(startedOn: startedOn);

  Success toSuccess({@required DateTime now}) {
    return Success(
      startedOn: startedOn,
      timeItTookToRun: now.difference(startedOn),
    );
  }

  Failure toFailure(
      {@required DateTime now,
      @required dynamic error,
      StackTrace stackTrace}) {
    return Failure(
      startedOn: startedOn,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class PackageGetResultPresenter {
  PackageGetResultPresenter();

  void present(Stream<PackageGetResult> results) {
    results.listen((result) {
      result.status.listen((status) {
        final statusString = status.when(
          success: (success) => '✅',
          failure: (failure) => '⛔ Failure\n${failure.error}',
          running: (running) => '⚙ Running',
        );

        print(
            '[${result.package.type.toReadableString()}] ${result.package.name} $statusString');
      });
    });
  }
}
