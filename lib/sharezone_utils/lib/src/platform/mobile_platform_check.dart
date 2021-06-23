import 'dart:io' as io;
import 'models/platform.dart';

Platform getPlatform() {
  if (io.Platform.isAndroid) return Platform.android;
  if (io.Platform.isIOS) return Platform.iOS;
  if (io.Platform.isMacOS) return Platform.macOS;
  if (io.Platform.isWindows) return Platform.windows;
  if (io.Platform.isLinux) return Platform.linux;
  return Platform.other;
}
