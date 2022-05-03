//
//  main.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin on 09.02.2022.
//
//  Copyright © 2022 Mikhail Zhigulin. All rights reserved.
//

import UIKit
import PerseusDarkMode

// MARK: - The Application Object Initiation

let appDelegateClass: AnyClass = NSClassFromString("TestingAppDelegate") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  nil,
                  NSStringFromClass(appDelegateClass))

// MARK: - The Application Delegate

class AppDelegate: UIResponder { var window: UIWindow? }

extension AppDelegate: UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        #if DEBUG
        print(">> Launching with real app delegate")
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        // Register Settings Bundle
        registerSettingsBundle()
        
        // Init the app's window
        window = UIWindowAdaptable(frame: UIScreen.main.bounds)
        
        // Give it a root view for the first screen
        window!.rootViewController = MainViewController.storyboardInstance()
        window!.makeKeyAndVisible()
        
        // And, finally, apply a new style for all screens
        //AppearanceService.makeUp()
        
        return true
    }
}
