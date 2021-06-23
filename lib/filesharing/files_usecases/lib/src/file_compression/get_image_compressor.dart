import 'image_compressor.dart';
import 'implementation/stub_image_compressor.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/mobile_native_image_compressor.dart'
    as implementation;

ImageCompressor getImageCompressor() {
  return implementation.getImageCompressor();
}
