//
//  AppDelegate.swift
//  Revagro Trasport
//
//  Created by ATPL on 01/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import IQDropDownTextField
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var googleApiKey = "AIzaSyB1g2zjTP66BLGD5aVjk2K4hfP9xU3Uq0M"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleApiKey)
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().barTintColor = RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR
        UINavigationBar.appearance().tintColor = RevagroColors.NAVIGATIONBAR_TITLE_COLOR
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.font: UIFont(name: "Arial", size: 30)!]
        
        
        // chnage rootViewController
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if user == nil{
                let vc = ViewController.instantiateVC()
                let nav = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
        if(Auth.auth().currentUser != nil){

           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
            
        
            
        }else{
            
        }
        
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

