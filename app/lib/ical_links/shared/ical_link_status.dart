enum ICalLinkStatus {
  /// The link is in the process of being created or updated.
  building,

  /// The link is available for use.
  available,

  /// The link is locked and cannot be used.
  ///
  /// This could be because the Sharezone Plus subscription has expired. Once
  /// the subscription is renewed, the link will be available again.
  locked,
}
