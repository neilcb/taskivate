//
//  AppDelegate.swift
//  taskivate
//
//  Created by Neil Baron on 5/2/18.
//  Copyright © 2018 taskivate. All rights reserved.
//

import Firebase
import FirebaseAuthUI
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    let log = SwiftyBeaver.self
    
    override init() {
        super.init()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }
    
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       
        
        let db = Firestore.firestore()
        // [END default_firestore]
        print(db) // silence warning
        SwiftyBeaver.info("setting up swiftybeaver")
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        
        let platform = SBPlatformDestination(appID: "E9QGpG", appSecret: "ahnAvgoe4Yjen6Eqck4m9Qlok9XeigmQ", encryptionKey: "xvgqyng6wlueisro7ttxtmug5xZnmwjd")
        
        log.addDestination(platform)
        log.addDestination(console)
        log.addDestination(file)
        SwiftyBeaver.info("logging set up")
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor(r: 67, g: 133, b: 203)
        
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Sansation-Bold", size: 20)!
        ]
        
        UILabel.appearance().font = UIFont(name: "Sansation-Light", size: 14)!
        
        
        navigationBarAppearace.titleTextAttributes = attrs
        let fontRegular = UIFont(name: "Sansation-Bold", size: 15)!
        UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).font = fontRegular
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Users", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: navigationBarAppearace.barTintColor!]
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = CustomTabBarController();
        
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        // other URL handling goes here.
        
        
        
        
        
        
        return false
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
}

