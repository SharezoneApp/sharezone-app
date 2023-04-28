import 'package:sharezone_utils/platform.dart';

/// Returns true if the current platform supports Firebase Messaging.
bool isFirebaseMessageSupported() {
  if (PlatformCheck.isMobile) return true;
  if (PlatformCheck.isMacOS) return true;

  // Currently, we are not able to set up Firebase Messaging on web because of
  // https://github.com/firebase/flutterfire/issues/10870.
  //
  // if (PlatformCheck.isWeb) return true;

  return false;
}
