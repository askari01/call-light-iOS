
//  AppDelegate.swift
//  FirebaseSocialLogin
//
//  Created by Brian Voong on 10/21/16.
//  Copyright © 2016 Lets Build That App. All rights reserved.
//

import Alamofire
import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import UserNotifications
import SwiftyJSON
import IQKeyboardManagerSwift
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var notif = UserDefaults.standard
    var token = UserDefaults.standard
    
    var destinationController: UINavigationController!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // for Keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        // for Google SDK
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // FB SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            (granted,error) in
            if granted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("User Notification permission denied: \(String(describing: error?.localizedDescription))")
                Defaults.set("-1", forKey: "deviceToken")
            }
        })
        
        application.applicationIconBadgeNumber + 1
        
//        Defaults.set("Nurse", forKey: "UserType")
//        Defaults.set("-1", forKey: "deviceToken")
        
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func tokenString(_ deviceToken:Data) -> String{
        //code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        self.token.set(token, forKey: "deviceToken")
        Defaults.set(token, forKey: "deviceToken")
        return token
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // will add token later to deal with
        print("Successful registration. Token is:")
        print(tokenString(deviceToken))
        print ("device token is",UserDefaults.standard.string(forKey: "deviceToken")!)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications")
        Defaults.set("-1", forKey: "deviceToken")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                          annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        application.applicationIconBadgeNumber + 1
//        print("Data is as follow: ",userInfo)
        let json = JSON(userInfo)
        print ("json1: ", json)
//        print ("res1: ", json["aps"])
//        print ("res2: ", json["hospital"])
//        print ("res3: ", json["hospital_request"])
//        print (json["aps"]["alert"].string)
        
        if application.applicationState == .active {
            var cancelTitle: String = "Close"
            var showTitle: String = "Update"
            var message: String? = json["aps"]["alert"].string!
            var alertView = UIAlertView(title: showTitle, message: message!, delegate: self, cancelButtonTitle: cancelTitle)
            alertView.show()
        }
        
        if json["hospital"] != nil && UserDefaults.standard.string(forKey: "UserType") != "" {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HospitalProfileView") as? HospitalProfile {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                controller.requestID = json["request_id"].int
                controller.latitude = json["hospital"]["latitude"].double
                controller.longitude = json["hospital"]["longitude"].double
                Defaults.set(json["hospital"]["latitude"].double, forKey: "HospitalLat")
                Defaults.set(json["hospital"]["longitude"].double, forKey: "HospitalLong")
                print ("latitude: ",json["hospital"]["latitude"].double)
                print ("longitude: ",json["hospital"]["longitude"].double)
                controller.name = json["hospital"]["name"].string
                controller.shiftStartTime = json["hospital_request"]["shift_start_time"].string
                controller.shiftEndTime = json["hospital_request"]["shift_end_time"].string
                controller.shiftDate = json["hospital_request"]["shift_date"].string
//              controller.avatarUrl = json["hospital"]["user"]["avatar_url"].string!
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
            }
        } else {
            
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
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

