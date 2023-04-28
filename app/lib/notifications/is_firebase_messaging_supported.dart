import 'package:sharezone_utils/platform.dart';

/// Returns true if the current platform supports Firebase Messaging.
///
/// There might be cases where Firebase officially supports a platform, but the
/// Flutter plugin does not. In this case, this method will return false.
bool isFirebaseMessageSupported() {
  if (PlatformCheck.isMobile) return true;
  if (PlatformCheck.isMacOS) return true;
  return false;
}
