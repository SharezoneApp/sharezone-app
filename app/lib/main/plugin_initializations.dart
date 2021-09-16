import 'package:dynamic_links/dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PluginInitializations {
  const PluginInitializations(
      {this.remoteConfiguration,
      this.crashAnalytics,
      this.dynamicLinks,
      this.sharedPreferences,
      this.streamingSharedPreferences});

  final RemoteConfiguration remoteConfiguration;
  final CrashAnalytics crashAnalytics;
  final DynamicLinks dynamicLinks;
  final SharedPreferences sharedPreferences;
  final StreamingSharedPreferences streamingSharedPreferences;

  static Future<CrashAnalytics> initializeCrashAnalytics() async {
    final crashAnalytics = getCrashAnalytics();
    crashAnalytics.enableInDevMode = true;
    return crashAnalytics;
  }

  /// Unter der User-ID "$RCAnonymousID:7689187fe95f4116bd0239217a211465" wurde
  /// bereits ein In-App-Kauf getätigt (donation_1_play_store). Diese User-ID
  /// kann beim Debuggen genutzt werden, um Daten von Käufern abzufragen.
  static Future<void> tryInitializeRevenueCat(
      {@required String apiKey, @required String uid}) async {
    // Web wird vom RevenueCat-Package nicht unterstützt
    if (!PlatformCheck.isWeb) {
      try {
        if (!kReleaseMode) await Purchases.setDebugLogsEnabled(true);
        await Purchases.setup(apiKey, appUserId: uid);
      } catch (e) {
        print('RevenueCat konnte nicht inizialisiert werden: $e');
      }
    }
  }

  static Future<DynamicLinks> initializeDynamicLinks() async {
    final dynamicLinks = getDynamicLinks();
    return dynamicLinks;
  }

  static Future<RemoteConfiguration> initializeRemoteConfiguration() async {
    final remoteConfiguration = getRemoteConfiguration();

    await remoteConfiguration.initialize({
      'meeting_server_url': 'https://meet.sharezone.net',
      'abgaben_bucket_name': 'sharezone-c2bd8-submissions',
      'abgaben_service_base_url': 'https://api.sharezone.net',
      'revenuecat_api_key': 'WLjPXTYvlcvxwFKOXWuHxDvKteGhqVpQ',
    });
    return remoteConfiguration;
  }

  static Future<SharedPreferences> initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<StreamingSharedPreferences>
      initializeStreamingSharedPreferences() async {
    final prefs = await StreamingSharedPreferences.instance;
    return prefs;
  }
}

Future<PluginInitializations> runPluginInitializations() async {
  final futureRemoteConfiguration =
      PluginInitializations.initializeRemoteConfiguration();
  final futureSharedPrefs = PluginInitializations.initializeSharedPreferences();
  final futureStreamingSharedPrefs =
      PluginInitializations.initializeStreamingSharedPreferences();
  final futureCrashAnalytics = PluginInitializations.initializeCrashAnalytics();
  final futureDynamicLinks = PluginInitializations.initializeDynamicLinks();

  final result = await Future.wait([
    futureSharedPrefs,
    futureRemoteConfiguration,
    futureStreamingSharedPrefs,
    futureCrashAnalytics,
    futureDynamicLinks,
  ]);
  return PluginInitializations(
    sharedPreferences: result[0] as SharedPreferences,
    remoteConfiguration: result[1] as RemoteConfiguration,
    streamingSharedPreferences: result[2] as StreamingSharedPreferences,
    crashAnalytics: result[3] as CrashAnalytics,
    dynamicLinks: result[4] as DynamicLinks,
  );
}
