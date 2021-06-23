class UploadMetadata {
  /// Custom metadata set on this storage object.
  final Map<String, dynamic> customMetadata;

  /// The size of this object, in bytes.
  final int sizeBytes;

  const UploadMetadata({
    this.customMetadata,
    this.sizeBytes,
  });
}
