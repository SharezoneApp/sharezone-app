// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:crash_analytics/crash_analytics.dart';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:platform_check/platform_check.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PluginInitializations {
  const PluginInitializations({
    required this.remoteConfiguration,
    required this.crashAnalytics,
    required this.appLinks,
    required this.sharedPreferences,
    required this.streamingSharedPreferences,
  });

  final RemoteConfiguration remoteConfiguration;
  final CrashAnalytics crashAnalytics;
  final AppLinks appLinks;
  final SharedPreferences sharedPreferences;
  final StreamingSharedPreferences streamingSharedPreferences;

  static Future<CrashAnalytics> initializeCrashAnalytics() async {
    final crashAnalytics = getCrashAnalytics();
    crashAnalytics.enableInDevMode = true;
    return crashAnalytics;
  }

  static Future<void> tryInitializeRevenueCat({
    required String appleApiKey,
    required String androidApiKey,
    required String uid,
  }) async {
    // RevenueCat package is not supported on web.
    if (!PlatformCheck.isWeb) {
      try {
        if (!kReleaseMode) await Purchases.setLogLevel(LogLevel.debug);

        final apiKey = PlatformCheck.isAndroid ? androidApiKey : appleApiKey;
        await Purchases.configure(
          PurchasesConfiguration(apiKey)..appUserID = uid,
        );
      } catch (e, s) {
        log('RevenueCat could not be initialized: $e', error: e, stackTrace: s);
      }
    }
  }

  static Future<AppLinks> initializeDynamicLinks() async {
    final appLinks = AppLinks();
    return appLinks;
  }

  static Future<RemoteConfiguration> initializeRemoteConfiguration({
    required Flavor flavor,
  }) async {
    final remoteConfiguration = getRemoteConfiguration();

    remoteConfiguration.initialize({
      'abgaben_bucket_name': 'sharezone-c2bd8-submissions',
      'abgaben_service_base_url': 'https://api.sharezone.net',
      'revenuecat_api_apple_key': 'appl_VOCPKvkVdZsqpVeDkJQVCNemPbF',
      'revenuecat_api_android_key': 'goog_EyqDtrZhkswSqMAcfqawHGAqZnX',
      'firebase_messaging_vapid_key':
          'BNT7Da6B6wi-mUBcGrt-9HxeIJZsPTsPpmR8cae_LhgJPcSFb5j0T8o-r-oFV1xAtXVXfRPIZlgUJR3tx8mLbbA',
      'stripe_checkout_session_function_url':
          'https://europe-west1-sharezone-c2bd8.cloudfunctions.net/createStripeCheckoutSession',
      // Setting the ads_enabled to false will also have the positive side
      // effect that the ads won't be shown for the first app open which
      // provides a better user experience.
      'ads_enabled': false,
      'ad_content_url': 'https://sharezone.net',
      'ad_neighboring_urls':
          'https://sharezone.net/android,https://sharezone.net/ios',
    });

    try {
      // Since the web is never really restarted in the web, we need to fetch
      // the remote configuration right away.
      //
      // We depend on some values from our Remote Config in the dev environment,
      // so we can't use the "Load new values for next startup" strategy.
      if (PlatformCheck.isWeb || flavor == Flavor.dev) {
        await remoteConfiguration.fetch();
        await remoteConfiguration.activate();
      } else {
        await remoteConfiguration.activate();
        // We follow the "Load new values for next startup" strategy (see
        // https://firebase.google.com/docs/remote-config/loading) to reduce the
        // startup time of the app.
        //
        // First, we activate the fetched remote config from the last fetch. Then
        // we fetch the remote config in the background. The next time the app
        // starts, the fetched remote config will be available.
        unawaited(tryFetchRemoteConfiguration(remoteConfiguration));
      }
    } catch (e) {
      log('Remote configuration could not be initialized: $e');
    }

    return remoteConfiguration;
  }

  static Future<void> tryFetchRemoteConfiguration(
    RemoteConfiguration remoteConfiguration,
  ) async {
    try {
      await remoteConfiguration.fetch();
    } catch (e, s) {
      log('Remote configuration could not be fetched', error: e, stackTrace: s);
    }
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

  static Future<void> initializeDateFormatting() async {
    try {
      // We need to initialize the date formatting to get the correct locale
      // for the date formatting. Otherwise, the date formatting will be
      // in English.
      //
      // Copied from https://stackoverflow.com/a/69889853/8358501.
      Intl.systemLocale = await findSystemLocale();
    } catch (e) {
      log('Could not initialize date formatting: $e');
    }
  }
}

Future<PluginInitializations> runPluginInitializations({
  required Flavor flavor,
}) async {
  final futureRemoteConfiguration =
      PluginInitializations.initializeRemoteConfiguration(flavor: flavor);
  final futureSharedPrefs = PluginInitializations.initializeSharedPreferences();
  final futureStreamingSharedPrefs =
      PluginInitializations.initializeStreamingSharedPreferences();
  final futureCrashAnalytics = PluginInitializations.initializeCrashAnalytics();
  final futureDynamicLinks = PluginInitializations.initializeDynamicLinks();
  final futureDateFormatting = PluginInitializations.initializeDateFormatting();

  final result = await Future.wait([
    futureSharedPrefs,
    futureRemoteConfiguration,
    futureStreamingSharedPrefs,
    futureCrashAnalytics,
    futureDynamicLinks,
    futureDateFormatting,
  ]);
  return PluginInitializations(
    sharedPreferences: result[0] as SharedPreferences,
    remoteConfiguration: result[1] as RemoteConfiguration,
    streamingSharedPreferences: result[2] as StreamingSharedPreferences,
    crashAnalytics: result[3] as CrashAnalytics,
    appLinks: result[4] as AppLinks,
  );
}
