class DateiDownloadUrl {
  final String _url;

  /// Momentan wird nur darauf geprüft, dass die Url nicht leer ist.
  /// In Zukunft könnte man noch prüfen, dass es eine wirklich valide URL ist
  DateiDownloadUrl(this._url) {
    ArgumentError.checkNotNull(_url, 'downloadUrl');
    if (_url.isEmpty) {
      throw ArgumentError('Die Download-Url darf nicht leer sein');
    }
  }

  @override
  String toString() {
    return '$_url';
  }
}
