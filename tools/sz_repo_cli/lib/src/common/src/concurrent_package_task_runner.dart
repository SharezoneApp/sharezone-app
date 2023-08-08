// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:collection';

import 'package:optional/optional.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';
import 'package:sz_repo_cli/src/common/common.dart';

class ConcurrentPackageTaskRunner {
  late DateTime Function() _getCurrentDateTime;

  ConcurrentPackageTaskRunner({
    DateTime Function()? getCurrentDateTime,
  }) {
    _getCurrentDateTime = getCurrentDateTime ?? () => DateTime.now();
  }

  /// Run [runTask] for every [Package] emitted by the [packageStream].
  Stream<PackageTask> runTaskForPackages({
    /// Stream of packages for which [runTask] will be called.
    ///
    /// Most often this will be [SharezoneRepo.streamPackages], maybe with a
    /// filter (e.g. `.where((package) => package.hasTestDirectory`) or
    /// something similar.
    required Stream<Package> packageStream,
    required Future<void> Function(Package package) runTask,

    /// If 0, null or negative then every package will be processed at once.
    /// Else [maxNumberOfPackagesBeingProcessedConcurrently] are processed
    /// concurrently,
    required int? maxNumberOfPackagesBeingProcessedConcurrently,

    /// After which [Duration] the task for a package will be marked as a
    /// [Failure].
    required Duration perPackageTaskTimeout,
  }) async* {
    final _concurrencyTransformer = _MaxConcurrentPackageStreamTransformer(
        maxConcurrentItems: maxNumberOfPackagesBeingProcessedConcurrently);

    final futures = <Future>[];

    await for (final package
        in packageStream.transform(_concurrencyTransformer)) {
      final _statusUpdater = _getStatusUpdater(package);
      yield PackageTask(package, _statusUpdater.statusStream);

      _statusUpdater.started();
      final future = runTask(package)
          .timeout(
            perPackageTaskTimeout,
            onTimeout: () =>
                throw PackageTimeoutException(perPackageTaskTimeout, package),
          )
          .then((_) => _statusUpdater.success())
          .catchError((e, s) => _statusUpdater.failure(error: e, stackTrace: s))
          .whenComplete(_concurrencyTransformer.notifyPackageProcessed);

      futures.add(future);
    }

    await Future.wait(futures);
    return;
  }

  _PackageTaskStatusUpdater _getStatusUpdater(Package package) =>
      _PackageTaskStatusUpdater(
        package: package,
        getCurrentDateTime: _getCurrentDateTime,
      );
}

class _MaxConcurrentPackageStreamTransformer
    extends StreamTransformerBase<Package, Package> {
  final int? maxConcurrentItems;
  int currentConcurrentItems = 0;
  final _waitingPackagesQueue = Queue<Completer>();
  bool noConcurrencyLimit = false;

  _MaxConcurrentPackageStreamTransformer._({
    required int this.maxConcurrentItems,
  })  : noConcurrencyLimit = false,
        assert(maxConcurrentItems != 0),
        assert(maxConcurrentItems > 0);

  _MaxConcurrentPackageStreamTransformer.noConcurrencyLimit()
      : noConcurrencyLimit = true,
        maxConcurrentItems = null;

  factory _MaxConcurrentPackageStreamTransformer({
    required int? maxConcurrentItems,
  }) {
    if (maxConcurrentItems == null || maxConcurrentItems <= 0) {
      return _MaxConcurrentPackageStreamTransformer.noConcurrencyLimit();
    }
    return _MaxConcurrentPackageStreamTransformer._(
      maxConcurrentItems: maxConcurrentItems,
    );
  }

  /// Notifies that a package that package has been finished being processed.
  ///
  /// This means that the next package can be processed.
  void notifyPackageProcessed() {
    if (noConcurrencyLimit) return;

    assert(currentConcurrentItems > 0);
    if (_waitingPackagesQueue.isNotEmpty) {
      _waitingPackagesQueue.removeFirst().complete();
    }
    currentConcurrentItems -= 1;
  }

  @override
  Stream<Package> bind(Stream<Package> stream) async* {
    if (noConcurrencyLimit) {
      yield* stream;
      return;
    }

    await for (final package in stream) {
      if (currentConcurrentItems < maxConcurrentItems!) {
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

class _PackageTaskStatusUpdater {
  final Package package;
  final DateTime Function() getCurrentDateTime;
  final _controller = BehaviorSubject<PackageTaskStatus>();
  Stream<PackageTaskStatus> get statusStream => _controller;
  Running? _running;

  _PackageTaskStatusUpdater({
    required this.package,
    required this.getCurrentDateTime,
  });

  void started() {
    _running = Running.since(
      package: package,
      startedOn: getCurrentDateTime(),
    );
    _controller.add(_running!);
  }

  void success() {
    if (_running == null) {
      throw StateError('success can only be called after calling running');
    }
    _controller.add(_running!.toSuccess(now: getCurrentDateTime()));
    _controller.close();
  }

  void failure({required dynamic error, StackTrace? stackTrace}) {
    if (_running == null) {
      throw StateError('failure can only be called after calling running');
    }
    _controller.add(_running!.toFailure(
      error: error,
      stackTrace: stackTrace,
      now: getCurrentDateTime(),
    ));
    _controller.close();
  }
}

class PackageTask {
  final Package package;
  final Stream<PackageTaskStatus> status;

  PackageTask(this.package, this.status);
}

abstract class PackageTaskStatus {
  final Package package;
  final DateTime startedOn;

  PackageTaskStatus({
    required this.package,
    required this.startedOn,
  });

  FutureOr<T> when<T>({
    required FutureOr<T> Function(Success) success,
    required FutureOr<T> Function(Failure) failure,
    required FutureOr<T> Function(Running) running,
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

extension StreamIsNotEmptyExtension on Stream {
  Future<bool> get isNotEmpty async => !(await isEmpty);
}

class Success extends PackageTaskStatus {
  final Duration timeToFinish;

  Success({
    required Package package,
    required DateTime startedOn,
    required this.timeToFinish,
  }) : super(package: package, startedOn: startedOn);
}

class Failure extends PackageTaskStatus {
  final dynamic error;
  final Optional<StackTrace> stackTrace;
  final Duration timeToFinish;

  Failure({
    required Package package,
    required DateTime startedOn,
    required this.timeToFinish,
    required this.error,
    StackTrace? stackTrace,
  })  : stackTrace = Optional.ofNullable(stackTrace),
        super(package: package, startedOn: startedOn);
}

class Running extends PackageTaskStatus {
  Running.since({
    required Package package,
    required DateTime startedOn,
  }) : super(package: package, startedOn: startedOn);

  Success toSuccess({required DateTime now}) {
    return Success(
      package: package,
      startedOn: startedOn,
      timeToFinish: now.difference(startedOn),
    );
  }

  Failure toFailure({
    required DateTime now,
    required dynamic error,
    StackTrace? stackTrace,
  }) {
    return Failure(
      package: package,
      startedOn: startedOn,
      timeToFinish: now.difference(startedOn),
      error: error,
      stackTrace: stackTrace,
    );
  }
}

extension TaskStatesExtension on Stream<PackageTask> {
  Future<List<Failure>> get allFailures => map((event) => event.status)
      .asyncExpand((status) => status)
      .whereType<Failure>()
      .toList();

  Future<List<Success>> get allSuccesses => map((event) => event.status)
      .asyncExpand((status) => status)
      .whereType<Success>()
      .toList();
}

class PackageTasksStatusPresenter {
  PackageTasksStatusPresenter();

  void continuouslyPrintTaskStatusUpdatesToConsole(
      Stream<PackageTask> tasksStream) {
    tasksStream.listen((task) {
      task.status.listen((event) {
        final status = event.when(
          success: (success) => '✅',
          failure: (failure) => '⛔ Failure\n${failure.error}',
          running: (running) => '⚙ Running',
        );

        print('${task.package.name} $status');
      });
    });
  }

  Future<void> printFailedTasksSummary(List<Failure> failures) async {
    for (var failure in failures) {
      print(
          '⛔ [${failure.package.type.toReadableString()}] ${failure.package.name}');
    }
  }
}
