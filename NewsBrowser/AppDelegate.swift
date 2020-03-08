//
//  AppDelegate.swift
//  NewsBrowser
//
//  Created by Sandra Morcos on 3/8/20.
//  Copyright © 2020 Sandra Morcos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let rootViewController: UIViewController?
        if Constants.favoriteCountry != nil {
            let storyboard = UIStoryboard(name: Storyboards.main.rawValue, bundle: Bundle.main)
            rootViewController = storyboard.instantiateInitialViewController()
        } else {
            let storyboard = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: Bundle.main)
            let onboardingVC = storyboard.instantiateViewController(withIdentifier: ViewControllers.onboarding.rawValue)
            rootViewController = UINavigationController(rootViewController: onboardingVC)
        }
        window?.rootViewController = rootViewController
        return true
    }


}

