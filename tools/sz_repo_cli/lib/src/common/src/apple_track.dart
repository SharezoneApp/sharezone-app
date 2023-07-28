/// A track to publish the app (iOS or macOS) for Apple.
abstract class AppleTrack {
  const AppleTrack();
}

/// The track for the App Store.
///
/// https://appstoreconnect.apple.com/apps/1434868489/appstore
class AppStoreTrack extends AppleTrack {
  const AppStoreTrack();
}

/// The track for TestFlight.
///
/// https://appstoreconnect.apple.com/apps/1434868489/testflight
class TestFlightTrack extends AppleTrack {
  /// The name of the TestFlight group.
  final String groupName;

  const TestFlightTrack(this.groupName);
}
