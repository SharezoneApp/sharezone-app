import 'models/platform.dart';

Platform getPlatform() => throw UnsupportedError(
    'Cannot create a client without dart:html or dart:io.');
