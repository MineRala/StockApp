//
//  AppDelegate.swift
//  StockApp
//
//  Created by Mine Rala on 19.09.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = HomeViewController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }


}

