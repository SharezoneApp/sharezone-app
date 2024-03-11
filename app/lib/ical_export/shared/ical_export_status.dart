enum ICalExportStatus {
  /// The export is in the process of being created or updated.
  building,

  /// The export is available for use.
  available,

  /// The export is locked and cannot be used.
  ///
  /// This could be because the Sharezone Plus subscription has expired. Once
  /// the subscription is renewed, the export will be available again.
  locked,
}
