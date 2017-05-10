//
//  AppDelegate.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
var remindTime: Double = 60.0 * 60.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowed, error) in
            // Handle Code Goes here
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // to show notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        var trigger: UNTimeIntervalNotificationTrigger?
        var request: UNNotificationRequest?
        
        if response.actionIdentifier == "remindInOne"{
            print("Remind in 1 Hour..")
            remindTime = 60.0 * 60.0 * 1.0
            print("Remind time: \(remindTime)")
            
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: remindTime, repeats: false)
            request = UNNotificationRequest(identifier: "Any", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request!, withCompletionHandler: nil)
            
        }else if response.actionIdentifier == "remindInTwo"{
            print("Remind in 2 Hour..")
            remindTime = 60.0 * 60.0 * 2.0
            print("Remind time: \(remindTime)")
            
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: remindTime, repeats: false)
            request = UNNotificationRequest(identifier: "Any", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request!, withCompletionHandler: nil)
            
        }else if response.actionIdentifier == "dismiss"{
            remindTime = 0.0
            print("Dismiss Reminder.")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Any"])
        }
        
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

