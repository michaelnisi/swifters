//
//  AppDelegate.swift
//  Swifters
//
//  Created by Michael Nisi on 04.12.18.
//  Copyright © 2018 Michael Nisi. All rights reserved.
//

import UIKit
import os.log

private let log = OSLog(subsystem: "ink.codes.swifter", category: "app")

struct Configuration: Codable {
  let token: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window?.tintColor = UIColor(named: "Orange")

    let bundle = Bundle(for: AppDelegate.classForCoder())
    let url = bundle.url(forResource: "config", withExtension: "json")!
    let json = try! Data(contentsOf: url)
    let conf = try! JSONDecoder().decode(Configuration.self, from: json)

    os_log("using configuration: %@", log: log, type: .info, String(describing: conf))

    UserDefaults.standard.register(defaults: [
      "token": conf.token
    ])

    return true
  }

  var userList: UserCollectionViewController? {
    guard let root = window?.rootViewController,
      let container = root as? UINavigationController else {
      return nil
    }

    return container.topViewController as? UserCollectionViewController
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    os_log("clearing cache", log: log)

    GitHub.shared.clearCache().catch { error in
      os_log("cache not cleared: %{public}@", log: log, error as CVarArg)
    }
  }

  func application(
    _ application: UIApplication,
    supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
    guard let tc = window?.traitCollection else {
      return .portrait
    }

    let regular = UITraitCollection(traitsFrom: [
      UITraitCollection(horizontalSizeClass: .regular),
      UITraitCollection(verticalSizeClass: .regular)
    ])

    guard tc.containsTraits(in: regular) else {
      return .portrait
    }

    return .allButUpsideDown
  }

}
