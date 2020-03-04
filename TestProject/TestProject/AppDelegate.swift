//
//  AppDelegate.swift
//  TestProject
//
//  Created by Rajaram on 26/02/20.
//  Copyright © 2020 Rajaram. All rights reserved.
//

import UIKit
import REIOSSDK
import UserNotifications
import Firebase

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let rootVc = ViewController()
        rootVc.view.backgroundColor = .red
//        window?.rootViewController = rootVc
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "nav")
        window?.rootViewController = controller

        
        initIntSdk()
        return true
    }
    
    private func initIntSdk() {
        REiosHandler.debug = true;
        FirebaseApp.configure();
        REiosHandler.initWithApi(apiKey: "e00f9d0b-8390-11e9-ab0f-06ab9bb94413", registerNotificationCategory: []);
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("") { string, byte in
                   string + String(format: "%02X", byte)
               
        }
        
         Messaging.messaging().apnsToken = deviceToken
               
               InstanceID.instanceID().instanceID(handler: { (result, error) in
                   if let error = error {
                       print("Error fetching remote instange ID")
                   } else if let result = result {
                       print("Remote instance ID token \(result.token)")
                   }
               })
               
               if let _fcmToken = Messaging.messaging().fcmToken {
                   print("Fcm token \(_fcmToken)")
                  UserDefaults.standard.set(_fcmToken, forKey: "token")
                   UserDefaults.standard.synchronize()
                   
                
               }
       
       
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error : \(error)")
    }
    


}

@available(iOS 13.0, *)
extension AppDelegate {
    
    //MARK: - Open link delegate
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print(url)
        
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        REiosHandler.unreadNotificationCount(onSuccess: { (count) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unread"), object: count)
            }
            
           
        }) { (count) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unread"), object: count)
            }
            
        }
    }
}



