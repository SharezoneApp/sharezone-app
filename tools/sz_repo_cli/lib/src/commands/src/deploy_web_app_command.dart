import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:sz_repo_cli/src/common/common.dart';

const _debugConfig = 'firebase_init_debug.js';
const _prodConfig = 'firebase_init_release.js';

// All apps are deployed in the production firebase project but under different
// domains.
// All apps also have the production config (they use and display the production
// data).
final _webAppConfigs = {
  'alpha': _WebAppConfig('alpha-web-app', 'sharezone-c2bd8', _prodConfig),
  'beta': _WebAppConfig('beta-web-app', 'sharezone-c2bd8', _prodConfig),
  'prod': _WebAppConfig('release-web-app', 'sharezone-c2bd8', _prodConfig),
};

/// Deploy the Sharezone web app to one of the several deploy sites (e.g. alpha
/// or production).
///
/// The command will automatically use the right firebase config as configured
/// inside [_webAppConfigs].
class DeployWebAppCommand extends Command {
  final SharezoneRepo _repo;

  DeployWebAppCommand(this._repo) {
    argParser
      ..addOption(
        releaseStageOptionName,
        abbr: 's',
        allowed: _webAppStages,
        allowedHelp: _deployCommandStageOptionHelp,
      )
      ..addOption(
        firebaseDeployMessageOptionName,
        help:
            '(Optional) The message given to "firebase deploy --only:hosting" via the "--message" flag. Will default to the current commit hash.',
      )
      ..addOption(
        googleApplicationCredentialsOptionName,
        help:
            'Path to location of credentials .json file used to authenticate deployment. Should only be used for CI/CD, developers should use "firebase login" instead.',
      );
  }

  Iterable<String> get _webAppStages => _webAppConfigs.keys;

  /// Used for helper text for deploy command.
  Map<String, String> get _deployCommandStageOptionHelp =>
      _webAppConfigs.map<String, String>((key, value) => MapEntry(
          key, '${value.firebaseProjectId}: ${value.deployTargetName}'));

  static const releaseStageOptionName = 'stage';
  static const firebaseDeployMessageOptionName = 'message';
  static const googleApplicationCredentialsOptionName = 'credentials';

  @override
  String get description =>
      'Deploy the Sharezone web app in the given environment';

  @override
  String get name => 'web-app';

  @override
  Future<void> run() async {
    // Its less work to just print everything right now instead of selectively
    // print and add custom print statements for non-verboes output.
    // One might add non-verbose output in the future but right now this is
    // easier.
    isVerbose = true;

    final googleApplicationCredentialsFile = _parseCredentialsFile(argResults);

    final overriddenDeployMessageOrNull = _parseDeployMessage(argResults);
    final releaseStage = _parseReleaseStage(argResults);
    final webAppConfig = _getMatchingWebAppConfig(releaseStage);

    final webAppIndexHtmlFile = File(path.join(
        _repo.sharezoneFlutterApp.location.path, 'web', 'index.html'));
    _replaceFirebaseConfig(webAppIndexHtmlFile,
        oldConfigName: _debugConfig,
        newConfigName: webAppConfig.firebaseConfigFileName);

    try {
      await runProcessSucessfullyOrThrow(
        'flutter',
        [
          'build',
          'web',
          '--release',
          '--dart-define=FLUTTER_WEB_USE_SKIA=true'
        ],
        workingDirectory: _repo.sharezoneFlutterApp.location.path,
      );

      String deployMessage;
      if (overriddenDeployMessageOrNull == null) {
        final currentCommit = await _getCurrentCommitHash();
        deployMessage = 'Commit: $currentCommit';
      }

      await runProcessSucessfullyOrThrow(
          'firebase',
          [
            'deploy',
            '--only',
            'hosting:${webAppConfig.deployTargetName}',
            '--project',
            webAppConfig.firebaseProjectId,
            '--message',
            deployMessage ?? overriddenDeployMessageOrNull,
          ],
          workingDirectory: _repo.sharezoneFlutterApp.location.path,

          // If we run this inside the CI/CD system we want this call to be
          // authenticated via the GOOGLE_APPLICATION_CREDENTIALS environment
          // variable.
          //
          // Unfortunately it doesn't work to export the environment variable
          // inside the CI/CD job and let the firebase cli use it automatically.
          // Even when using [Process.includeParentEnvironment] the variables
          // are not passed to the firebase cli.
          //
          // Thus the CI/CD script can pass the
          // [googleApplicationCredentialsFile] manually via an command line
          // option and we set the GOOGLE_APPLICATION_CREDENTIALS manually
          // below.
          environment: {
            if (googleApplicationCredentialsFile != null)
              'GOOGLE_APPLICATION_CREDENTIALS':
                  googleApplicationCredentialsFile.absolute.path,
          });
    } finally {
      // Even if we fail to build or deploy we want to reset the web config
      // back to the debug config. Otherwise developers might unexpectedly
      // use the production project for developing purposes.
      _replaceFirebaseConfig(webAppIndexHtmlFile,
          oldConfigName: webAppConfig.firebaseConfigFileName,
          newConfigName: _debugConfig);
    }
  }

  File _parseCredentialsFile(ArgResults _argResults) {
    File googleApplicationCredentialsFile;
    final _path = _argResults[googleApplicationCredentialsOptionName] as String;
    if (_path != null) {
      googleApplicationCredentialsFile = File(_path);
      final exists = googleApplicationCredentialsFile.existsSync();
      if (!exists) {
        print(
            "--$googleApplicationCredentialsOptionName passed '$_path' but the file doesn't exist at this path. Working directory is ${Directory.current}");
      }
    }
    return googleApplicationCredentialsFile;
  }

  _WebAppConfig _getMatchingWebAppConfig(String releaseStage) {
    final _app = _webAppConfigs[releaseStage];

    if (_app == null) {
      print(
          'Given release stage $releaseStage does not match one the expected values: $_webAppStages');
      throw ToolExit(2);
    }

    if (isVerbose) {
      print('Got webApp config: $_app');
    }
    return _app;
  }

  String _parseReleaseStage(ArgResults _argResults) {
    final releaseStage = _argResults[releaseStageOptionName] as String;
    if (releaseStage == null) {
      print(
          'Expected --$releaseStageOptionName option. Possible values: $_webAppStages');
      throw ToolExit(1);
    }
    return releaseStage;
  }

  String _parseDeployMessage(ArgResults _argResults) {
    final overriddenDeployMessageOrNull =
        _argResults[firebaseDeployMessageOptionName] as String;
    return overriddenDeployMessageOrNull;
  }

  Future<String> _getCurrentCommitHash() async {
    final res = await runProcess('git', ['rev-parse', 'HEAD']);
    if (res.stdout == null || (res.stdout as String).isEmpty) {
      print(
          'Could not receive the current commit hash: (${res.exitCode}) ${res.stderr}.');
      throw ToolExit(15);
    }
    final currentCommit = res.stdout;
    if (isVerbose) {
      print('Got current commit hash: $currentCommit');
    }
    return currentCommit;
  }

  void _replaceFirebaseConfig(
    File indexHtmlFile, {
    @required String oldConfigName,
    @required String newConfigName,
  }) {
    final content = indexHtmlFile.readAsStringSync();
    final newContent = content.replaceAll(oldConfigName, newConfigName);
    if (content == newContent && oldConfigName != newConfigName) {
      print(
          'Replacing $oldConfigName with $newConfigName inside of ${indexHtmlFile.path} failed. This *might* have failed because $oldConfigName was not found inside the ${path.basename(indexHtmlFile.path)} when attempting to replace.');
      throw ToolExit(10);
    }
    indexHtmlFile.writeAsStringSync(newContent);

    if (isVerbose) {
      print('Replaced firebase config inside index.html with $newConfigName');
    }
  }
}

class _WebAppConfig {
  /// As in /app/.firebaserc
  final String deployTargetName;

  /// E.g. sharezone-c2bd8 or sharezone-debug
  final String firebaseProjectId;

  /// E.g. firebase_init_release.js
  /// Needs to be inside /app/web folder.
  final String firebaseConfigFileName;

  const _WebAppConfig(this.deployTargetName, this.firebaseProjectId,
      this.firebaseConfigFileName);

  @override
  String toString() =>
      '_WebApp(deployTargetName: $deployTargetName, firebaseProjectId: $firebaseProjectId, firebaseConfigFileName: $firebaseConfigFileName)';
}
