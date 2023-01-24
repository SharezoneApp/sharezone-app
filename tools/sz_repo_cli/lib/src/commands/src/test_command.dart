// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sz_repo_cli/src/common/common.dart';

class TestCommand extends Command {
  TestCommand._(this._useCase, this._presenter) {
    argParser
      ..addOption(
        maxConcurrentPackagesOptionName,
        abbr: 'c',
        defaultsTo: '5',
        help:
            'How many packages at most should be processed at once. Helpful for a CI or not as powerful PCs to not have so much processing at once.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'if verbose output should be printed (helpful for debugging)',
        negatable: false,
        defaultsTo: false,
      )
      ..addPackageTimeoutOption(defaultInMinutes: 7);
  }

  static const maxConcurrentPackagesOptionName = 'max-concurrent-packages';

  factory TestCommand(SharezoneRepo repo) {
    return TestCommand._(
        TestPackagesUseCase(
          repo: repo,
          getCurrentDateTime: () => DateTime.now(),
        ),
        TestPackagesResultPresenter());
  }

  final TestPackagesUseCase _useCase;
  final TestPackagesResultPresenter _presenter;

  @override
  final String name = 'test';

  @override
  final String description = 'Runs the Dart tests for all packages.\n\n'
      'This command requires "flutter" to be in your path.';

  @override
  Future<Null> run() async {
    isVerbose = argResults['verbose'] ?? false;

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null wird nachher als "keine Begrenzung" gehandhabt.
        : null;

    final res = _useCase
        .testAllPackages(
          maxNumberOfPackagesBeingProcessedConcurrently:
              maxNumberOfPackagesBeingProcessedConcurrently,
          packageTimeout: argResults.packageTimeoutDuration,
        )
        .asBroadcastStream();

    _presenter.present(res);

    final failures = await res
        .map((event) => event.status)
        .asyncExpand((status) => status)
        .whereType<Failure>()
        .toList();

    if (failures.isNotEmpty) {
      print('There were failures in the following packages:');
      for (var failure in failures) {
        print(
            '⛔ [${failure.package.type.toReadableString()}] ${failure.package.name}');
      }
      print(
          'Look for the output above this error message for more detailed information.');
      // "Fehler"-Exit-Code, damit die CI-Pipeline bei einem fehler fehlschlägt.
      exit(1);
    } else {
      print('All packages tested successfully!');
      exit(0);
    }
  }
}

extension on Stream {
  Future<bool> get isNotEmpty async => !(await isEmpty);
}

class TestPackagesUseCase {
  final SharezoneRepo repo;
  Duration packageTimeout;
  DateTime Function() _getCurrentDateTime;
  MaxConcurrentPackageStreamTransformer _maxConcurrentPackagesTransformer;

  TestPackagesUseCase({
    @required this.repo,
    DateTime Function() getCurrentDateTime,
  }) {
    _getCurrentDateTime = getCurrentDateTime ?? () => DateTime.now();
  }

  Stream<TestPackageResult> testAllPackages({
    /// If 0 or null then every package is process parallely.
    /// Else [maxNumberOfPackagesBeingProcessedConcurrently] are process concurrently,
    int maxNumberOfPackagesBeingProcessedConcurrently,

    /// See help in [AnalyzeCommand] for explanation
    @required Duration packageTimeout,
  }) {
    this.packageTimeout = packageTimeout;
    _setTransformer(maxNumberOfPackagesBeingProcessedConcurrently);
    return _testPackages(repo.streamPackages());
  }

  void _setTransformer(int maxNumberOfPackagesBeingProcessedConcurrently) {
    _maxConcurrentPackagesTransformer = MaxConcurrentPackageStreamTransformer(
        maxConcurrentItems:
            _sanitize(maxNumberOfPackagesBeingProcessedConcurrently));
  }

  int _sanitize(int maxNumberOfPackagesBeingProcessedConcurrently) {
    if (maxNumberOfPackagesBeingProcessedConcurrently == null ||
        maxNumberOfPackagesBeingProcessedConcurrently <= 0) {
      // "Unendlich"
      maxNumberOfPackagesBeingProcessedConcurrently = 99999;
    }
    return maxNumberOfPackagesBeingProcessedConcurrently;
  }

  Stream<TestPackageResult> _testPackages(
      Stream<Package> packageStream) async* {
    final futures = <Future>[];

    await for (final package in packageStream
        .where((package) => package.hasTestDirectory)
        .transform(_maxConcurrentPackagesTransformer)) {
      final _statusUpdater = _getStatusUpdater(package);
      yield TestPackageResult(package, _statusUpdater.statusStream);

      _statusUpdater.started();
      final future = package
          .runTests()
          .timeout(
            packageTimeout,
            onTimeout: () =>
                throw PackageTimeoutException(packageTimeout, package),
          )
          .then((_) => _statusUpdater.success())
          .catchError((e, s) => _statusUpdater.failure(error: e, stackTrace: s))
          .whenComplete(
              _maxConcurrentPackagesTransformer.notifyPackageProcessed);

      futures.add(future);
    }

    await Future.wait(futures);
    return;
  }

  PackageStatusUpdater _getStatusUpdater(Package package) =>
      PackageStatusUpdater(
          package: package, getCurrentDateTime: _getCurrentDateTime);
}

/// Wird dafür genutzt, dass maximal X Packages gleichzeitig verarbeitet werden.
class MaxConcurrentPackageStreamTransformer
    extends StreamTransformerBase<Package, Package> {
  final int maxConcurrentItems;
  int currentConcurrentItems = 0;
  final _waitingPackagesQueue = Queue<Completer>();

  MaxConcurrentPackageStreamTransformer({@required this.maxConcurrentItems})
      : assert(maxConcurrentItems != 0),
        assert(maxConcurrentItems > 0);

  /// Informiert diesen Transformer, dass ein Package (sei es erfolreich oder
  /// nicht) verarbeitet wurde und das nächste Package (falls die maximale
  /// Anzahl zuvor überschritten wurde) ausgegeben werden kann.
  void notifyPackageProcessed() {
    assert(currentConcurrentItems > 0);
    if (_waitingPackagesQueue.isNotEmpty) {
      _waitingPackagesQueue.removeFirst().complete();
    }
    currentConcurrentItems -= 1;
  }

  @override
  Stream<Package> bind(Stream<Package> stream) async* {
    await for (final package in stream) {
      if (currentConcurrentItems < maxConcurrentItems) {
        currentConcurrentItems++;
        yield package;
      } else {
        final completer = Completer();
        _waitingPackagesQueue.add(completer);
        await completer.future;
        currentConcurrentItems++;
        yield package;
      }
    }
  }
}

class PackageStatusUpdater {
  final Package package;
  final DateTime Function() getCurrentDateTime;
  final _controller = BehaviorSubject<TestPackageStatus>();
  Stream<TestPackageStatus> get statusStream => _controller;
  Running _running;

  PackageStatusUpdater({
    @required this.package,
    this.getCurrentDateTime,
  });

  void started() {
    _running = Running.since(package: package, startedOn: getCurrentDateTime());
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

class TestPackageResult {
  final Package package;
  final Stream<TestPackageStatus> status;

  TestPackageResult(this.package, this.status);
}

abstract class TestPackageStatus {
  final Package package;
  final DateTime startedOn;

  TestPackageStatus({
    @required this.package,
    @required this.startedOn,
  });

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

class Success extends TestPackageStatus {
  final Duration timeItTookToRun;

  Success({
    @required Package package,
    @required DateTime startedOn,
    @required this.timeItTookToRun,
  }) : super(package: package, startedOn: startedOn);
}

class Failure extends TestPackageStatus {
  final dynamic error;
  final Optional<StackTrace> stackTrace;

  Failure({
    @required Package package,
    @required this.error,
    StackTrace stackTrace,
    @required DateTime startedOn,
  })  : stackTrace = Optional.ofNullable(stackTrace),
        super(package: package, startedOn: startedOn);
}

class Running extends TestPackageStatus {
  Running.since({
    @required Package package,
    @required DateTime startedOn,
  }) : super(package: package, startedOn: startedOn);

  Success toSuccess({@required DateTime now}) {
    return Success(
      package: package,
      startedOn: startedOn,
      timeItTookToRun: now.difference(startedOn),
    );
  }

  Failure toFailure(
      {@required DateTime now,
      @required dynamic error,
      StackTrace stackTrace}) {
    return Failure(
      package: package,
      startedOn: startedOn,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class TestPackagesResultPresenter {
  TestPackagesResultPresenter();

  void present(Stream<TestPackageResult> results) {
    results.listen((result) {
      result.status.listen((event) {
        final status = event.when(
          success: (success) => '✅',
          failure: (failure) => '⛔ Failure\n${failure.error}',
          running: (running) => '⚙ Running',
        );

        print('${result.package.name} $status');
      });
    });
  }
}
