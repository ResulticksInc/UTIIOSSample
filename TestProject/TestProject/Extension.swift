//
//  Extension.swift
//  TestProject
//
//  Created by Rajaram on 26/02/20.
//  Copyright © 2020 Rajaram. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import REIOSSDK

extension UIViewController:UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Passing foreground notification data to REIOSSDK
        REiosHandler.getNotification()?.setForegroundNotification(notification: notification, completionHandler: {
            handler in
            REiosHandler.unreadNotificationCount(onSuccess: { (count) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unread"), object: count)
                }
                
               
            }) { (count) in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unread"), object: count)
                }
                
            }
            completionHandler(handler)
            
        })
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Notification action response \(response)")
        
        // Passing notification response data to REIOSSDK
        REiosHandler.getNotification()?.setNotificationAction(response: response)
        
        let data = response.notification.request.content.userInfo
        
        // Perform this to navigate screen only on click of Default notification action
        // Please ensure that you navigate screen based on the custom params
        // Here we are using screenUrl to navigate screen
       if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            
            if
                let _value = data["screenUrl"] as? String,
                _value != "" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: data["screenUrl"] as! String)
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
    }
}
