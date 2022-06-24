//
//  AppDelegate.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

import UIKit
import SwiftyBeaver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let log = SwiftyBeaver.self

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let console = ConsoleDestination()
        let cloud = SBPlatformDestination(appID: "OknqWo", appSecret: "gnagdulmIwld0vudxSbffmOhcdzhtyCn", encryptionKey: "defu2tzzxxbYbc1yiiayhzafQ7Eqiftn")

        // below is the default, which is what I want anyway
        // console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"

        log.addDestination(console)
        log.addDestination(cloud)

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

