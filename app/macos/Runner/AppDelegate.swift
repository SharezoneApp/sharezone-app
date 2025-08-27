// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import Cocoa
import FlutterMacOS
import app_links

@main
class AppDelegate: FlutterAppDelegate {
  // Added because of https://github.com/llfbandit/app_links/blob/master/doc/README_macos.md#universal-links-setup
  public override func application(_ application: NSApplication,
                                 continue userActivity: NSUserActivity,
                                 restorationHandler: @escaping ([any NSUserActivityRestoring]) -> Void) -> Bool {

  guard let url = AppLinks.shared.getUniversalLink(userActivity) else {
    return false
  }
  
  AppLinks.shared.handleLink(link: url.absoluteString)
  
  return false // Returning true will stop the propagation to other packages
}

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
