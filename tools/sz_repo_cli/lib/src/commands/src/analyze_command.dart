import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sz_repo_cli/src/common/common.dart';

class AnalyzeCommand extends Command {
  AnalyzeCommand._(this._useCase, this._presenter) {
    argParser
      ..addOption(
        maxConcurrentPackagesOptionName,
        abbr: 'c',
        defaultsTo: '5',
        help:
            'How many packages at most should be processed at once. Helpful for a CI or not as powerful PCs to not have so much processing at once.',
      )
      ..addPackageTimeoutOption(defaultInMinutes: 7);
  }

  static const maxConcurrentPackagesOptionName = 'max-concurrent-packages';

  factory AnalyzeCommand(SharezoneRepo repo) {
    return AnalyzeCommand._(
        AnalyzePackagesUseCase(
          repo: repo,
          getCurrentDateTime: () => DateTime.now(),
        ),
        AnalyzePackagesResultPresenter());
  }

  final AnalyzePackagesUseCase _useCase;
  final AnalyzePackagesResultPresenter _presenter;

  @override
  final String name = 'analyze';

  @override
  final String description = 'Analyzes all packages using package:tuneup.\n\n'
      'This command requires "pub" and "flutter" to be in your path.';

  @override
  Future<Null> run() async {
    print('Activating tuneup package...');
    await runAndStream('dart', ['pub', 'global', 'activate', 'tuneup'],
        workingDir: _useCase.repo.sharezoneFlutterApp.location,
        exitOnError: true);

    final _max = argResults[maxConcurrentPackagesOptionName];
    final maxNumberOfPackagesBeingProcessedConcurrently = _max != null
        ? int.tryParse(argResults[maxConcurrentPackagesOptionName])
        // null wird nachher als "keine Begrenzung" gehandhabt.
        : null;

    final res = _useCase
        .analyzePackages(
          maxNumberOfPackagesBeingProcessedConcurrently:
              maxNumberOfPackagesBeingProcessedConcurrently,
          packageTimeout: argResults.packageTimeoutDuration,
        )
        .asBroadcastStream();

    _presenter.present(res);

    final hasErrors = await res
        .map((event) => event.status)
        .asyncExpand((status) => status)
        .where((status) => status is Failure)
        .isNotEmpty;

    if (hasErrors) {
      print('There were failures. See above for more information.');
      // "Fehler"-Exit-Code, damit die CI-Pipeline bei einem fehler fehlschlägt.
      exit(1);
    } else {
      print('All packages analyzed successfully!');
      exit(0);
    }
  }
}

extension on Stream {
  Future<bool> get isNotEmpty async => !(await isEmpty);
}

class AnalyzePackagesUseCase {
  final SharezoneRepo repo;
  Duration packageTimeout;
  DateTime Function() _getCurrentDateTime;
  MaxConcurrentPackageStreamTransformer _maxConcurrentPackagesTransformer;

  AnalyzePackagesUseCase({
    @required this.repo,
    DateTime Function() getCurrentDateTime,
  }) {
    _getCurrentDateTime = getCurrentDateTime ?? () => DateTime.now();
  }

  Stream<AnalyzePackageResult> analyzePackages({
    /// If 0 or null then every package is process parallely.
    /// Else [maxNumberOfPackagesBeingProcessedConcurrently] are process concurrently,
    int maxNumberOfPackagesBeingProcessedConcurrently,

    /// See help in [AnalyzeCommand] for explanation
    @required Duration packageTimeout,
  }) {
    this.packageTimeout = packageTimeout;
    _setTransformer(maxNumberOfPackagesBeingProcessedConcurrently);
    return _analyzePackages(repo.streamPackages());
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

  Stream<AnalyzePackageResult> _analyzePackages(
      Stream<Package> packageStream) async* {
    final futures = <Future>[];

    await for (final package
        in packageStream.transform(_maxConcurrentPackagesTransformer)) {
      final _statusUpdater = _getStatusUpdater(package);
      yield AnalyzePackageResult(package, _statusUpdater.statusStream);

      _statusUpdater.started();
      final future = package
          .analyzePackage()
          .timeout(
            packageTimeout,
            onTimeout: () =>
                throw PackageTimoutException(packageTimeout, package),
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
  final _controller = BehaviorSubject<AnalyzePackageStatus>();
  Stream<AnalyzePackageStatus> get statusStream => _controller;
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

class AnalyzePackageResult {
  final Package package;
  final Stream<AnalyzePackageStatus> status;

  AnalyzePackageResult(this.package, this.status);
}

abstract class AnalyzePackageStatus {
  final DateTime startedOn;

  AnalyzePackageStatus({@required this.startedOn});

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

class Success extends AnalyzePackageStatus {
  final Duration timeItTookToRun;

  Success({
    @required DateTime startedOn,
    @required this.timeItTookToRun,
  }) : super(startedOn: startedOn);
}

class Failure extends AnalyzePackageStatus {
  final dynamic error;
  final Optional<StackTrace> stackTrace;

  Failure({
    @required this.error,
    StackTrace stackTrace,
    @required DateTime startedOn,
  })  : stackTrace = Optional.ofNullable(stackTrace),
        super(startedOn: startedOn);
}

class Running extends AnalyzePackageStatus {
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

class AnalyzePackagesResultPresenter {
  AnalyzePackagesResultPresenter();

  void present(Stream<AnalyzePackageResult> results) {
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
