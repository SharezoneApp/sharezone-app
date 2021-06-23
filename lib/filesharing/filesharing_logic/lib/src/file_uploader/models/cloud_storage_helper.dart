class CloudStorageBucket {
  final String name;
  Uri get uri => Uri.parse('gs://$name');

  CloudStorageBucket(this.name) {
    ArgumentError.checkNotNull(name, 'storageBucketName');
    if (name.isEmpty) {
      throw ArgumentError('Darf nicht leer sein.');
    }
  }

  /// Hier gibt man z.B. wenn der Bucket sharezone-debug.appspot.com
  /// ist den Pfad /files/file12 rein. Dann bekommt man ein [CloudStoragePfad]
  /// mit der URI gs://sharezone-debug.appspot.com/files/file12 zurück.
  CloudStoragePfad lokalerPfad(String pfad) {
    if (pfad.startsWith('/')) {
      throw ArgumentError.value(
          pfad, 'storagePfad', 'darf nicht mit "/" beginnen.');
    }
    return CloudStoragePfad(uri.replace(path: pfad));
  }

  @override
  String toString() {
    return '$uri';
  }
}

class CloudStoragePfad {
  /// [cloudStorageUri] muss ein absoluter Pfad mit einem "gs"-Schema sein.
  /// Beispiel: gs://sharezone-debug.appspot.com/files/file1
  CloudStoragePfad(Uri cloudStorageUri) : uri = cloudStorageUri {
    ArgumentError.checkNotNull(uri, 'cloudStorageUri');
    if (uri.scheme != 'gs') {
      ArgumentError.value(uri, 'cloudStorageUri',
          'Muss dem "gs"-Schema, z.B. gs://[Bucket-Name] entsprechen.');
    }
    if (!uri.isAbsolute) {
      ArgumentError.value(
          uri, 'cloudStorageUri', 'Muss eine absolute Uri sein.');
    }
  }

  /// Kurz für [CloudStoragePfad(Uri.parse(uri)))]
  factory CloudStoragePfad.parse(String uri) {
    return CloudStoragePfad(Uri.parse(uri));
  }

  /// Ob der Pfad auf eine Datei zeigt.
  /// Beispiele:
  /// * gs://sharezone-debug.appspot.com/files/file1 -> true
  /// * gs://sharezone-debug.appspot.com/files/file1/ -> false
  /// * gs://sharezone-debug.appspot.com/files -> false
  /// * gs://sharezone-debug.appspot.com/files/ -> true
  bool get istDateiPfad => uri.pathSegments.length.isEven;

  final Uri uri;

  /// sharezone-debug.appspot.com für gs://sharezone-debug.appspot.com/files/file1
  CloudStorageBucket get bucket => CloudStorageBucket(uri.authority);

  /// Der Pfad innerhalb des Buckets ohne dem Bucket-Name.
  ///
  /// z.B. "/files/file1" für gs://sharezone-debug.appspot.com/files/file1.
  String get lokalerPfad => uri.path;

  /// Wie [lokalerPfad] nur ohne das Anfangsslash
  String get lokalerPfadOhneAnfangsslash => uri.path.replaceFirst('/', '');

  @override
  String toString() => '$uri';
}
