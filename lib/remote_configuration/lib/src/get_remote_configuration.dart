import 'implementation/stub_remote_configuration.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/firebase_remote_configuration.dart'
    // ignore: uri_does_not_exist
    if (dart.library.js) 'implementation/firebase_web_remote_configuration.dart'
    as implementation;
import 'remote_configuration.dart';

RemoteConfiguration getRemoteConfiguration() {
  return implementation.getRemoteConfiguration();
}
