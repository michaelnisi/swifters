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
  

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
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
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  var userList: UserCollectionViewController? {
    guard let root = window?.rootViewController,
      let container = root as? UINavigationController else {
      return nil
    }

    return container.topViewController as? UserCollectionViewController
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    os_log("clearing cache", log: log)

    userList?.invalidateDataSource()

    // Shrugging it off by clearing the cache wholesale.

    GitHub.shared.clearCache().catch { error in
      os_log("cache not cleared: %{public}@", log: log, error as CVarArg)
    }
  }

  func application(
    _ application: UIApplication,
    supportedInterfaceOrientationsFor window: UIWindow?
  ) -> UIInterfaceOrientationMask {
    let o = window?.rootViewController?.supportedInterfaceOrientations

    guard let traitCollection = window?.traitCollection else {
      return o ?? .portrait
    }

    let regular = UITraitCollection(traitsFrom: [
      UITraitCollection(horizontalSizeClass: .regular),
      UITraitCollection(verticalSizeClass: .regular)
    ])

    if traitCollection.containsTraits(in: regular) {
      return o ?? .allButUpsideDown
    } else {
      return .portrait
    }
  }

}
