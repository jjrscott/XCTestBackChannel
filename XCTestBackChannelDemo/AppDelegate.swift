//
//  AppDelegate.swift
//  XCTestBackChannelDemo
//
//  Created by John Scott on 9/3/21.
//

import UIKit
import XCTestBackChannel

@main
class AppDelegate: UIResponder, UIApplicationDelegate, XCTestBackChannelDelegate {
    func testBackChannel(handleMessage message: String) {
        UIApplication.shared.windows.first?.rootViewController?.view.backgroundColor = UIColor(named: message)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        XCTestBackChannel.shared.delegate = self
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            XCTestBackChannel.shared.sendMessage("Hello")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

