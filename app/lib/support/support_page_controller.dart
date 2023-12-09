// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';

class SupportPageController extends ChangeNotifier {
  bool hasPlusSupportUnlocked = false;
  bool isUserInGroupOnboarding = false;
  UserId? userId;
  String? userEmail;
  String? userName;

  bool get isUserSignedIn => userId != null;

  late StreamSubscription<UserId?> _userIdSubscription;
  late StreamSubscription<String?> _userNameSubscription;
  late StreamSubscription<String?> _userEmailSubscription;
  late StreamSubscription<bool> _hasPlusSupportUnlockedSubscription;
  late StreamSubscription<bool> _isUserInGroupOnboardingSubscription;

  SupportPageController({
    required Stream<UserId?> userIdStream,
    required Stream<String?> userNameStream,
    required Stream<String?> userEmailStream,
    required Stream<bool> hasPlusSupportUnlockedStream,
    required Stream<bool> isUserInGroupOnboardingStream,
  }) {
    _userIdSubscription = userIdStream.listen((userId) {
      this.userId = userId;
      notifyListeners();
    });

    _userEmailSubscription = userEmailStream.listen((userEmail) {
      this.userEmail = userEmail;
      notifyListeners();
    });

    _userNameSubscription = userNameStream.listen((userName) {
      this.userName = userName;
      notifyListeners();
    });

    _hasPlusSupportUnlockedSubscription =
        hasPlusSupportUnlockedStream.listen((hasPlusSupportUnlocked) {
      this.hasPlusSupportUnlocked = hasPlusSupportUnlocked;
      notifyListeners();
    });

    _isUserInGroupOnboardingSubscription =
        isUserInGroupOnboardingStream.listen((isUserInGroupOnboarding) {
      this.isUserInGroupOnboarding = isUserInGroupOnboarding;
      notifyListeners();
    });
  }

  /// Returns the unencoded URL for the video call appointments page, with
  /// prefilled user ID, user name, and user email (for non-private Apple
  /// email).
  ///
  /// Example URL:
  /// ```
  /// https://sharezone.net/sharezone-plus-video-call-support?userId=userId123&name=My Cool Name&email=my@email.com
  /// ```
  /// Note: The URL is not encoded because the `launchURL` method will encode
  /// the URL.
  ///
  /// This method throws [UserNotAuthenticatedException] if the `userId` is
  /// `null`.
  String getVideoCallAppointmentsUnencodedUrlWithPrefills() {
    if (userId == null) {
      // Technically, this should never happen because the button to open the
      // appointments page is only visible when the user is signed in. However,
      // we still check for this case to be on the safe side.
      //
      // We throw an exception because the user ID is required for making an
      // appointment.
      throw UserNotAuthenticatedException();
    }

    // Add the user ID to prefill the user ID field in the form, aiding the
    // support team in identifying the user and the field required to make an
    // appointment.
    String url =
        'https://sharezone.net/sharezone-plus-video-call-support?userId=$userId';

    // Even though some users don't have an helpful user name, we still want to
    // prefill the name field with the user's name because it's helpful for
    // these users that have a helpful user name.
    if (userName != null) {
      url += '&name=$userName';
    }

    // Prefill the email field with the user's email address, unless it's a
    // private Apple email address, to which the appointment service can't send
    // emails.
    if (userEmail != null && !_isPrivateAppleEmail(userEmail!)) {
      url += '&email=$userEmail';
    }

    return url;
  }

  bool _isPrivateAppleEmail(String email) {
    return email.endsWith('@privaterelay.appleid.com') || email == '-';
  }

  @override
  void dispose() {
    _userIdSubscription.cancel();
    _userNameSubscription.cancel();
    _userEmailSubscription.cancel();
    _userIdSubscription.cancel();
    _hasPlusSupportUnlockedSubscription.cancel();
    _isUserInGroupOnboardingSubscription.cancel();
    super.dispose();
  }
}

class UserNotAuthenticatedException implements Exception {}
