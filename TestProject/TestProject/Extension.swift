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
        
        REiosHandler.getNotification()?.setForegroundNotification(notification: notification, completionHandler: {
            handler in
            completionHandler(handler)
        })
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let data = response.notification.request.content.userInfo
        
        if
            let _value = data["screenUrl"] as? String,
            _value != "" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: data["screenUrl"] as! String)
            
            if let topVc: UIViewController = UIApplication.topViewController1() {
                
                if UIApplication.shared.applicationState == .inactive {
                    //UIApplication.shared.keyWindow?.addSubview(loaderView())
                    let delayInSeconds = 5.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                        DispatchQueue.main.async {
                            UIApplication.shared.keyWindow?.viewWithTag(1001)?.removeFromSuperview()
                            
                        }
                        topVc.navigationController?.pushViewController(viewController, animated: false)
                    }
                }
            }
            return
        }
        
        print(data)
        
        if
            let _userInfo = data as? [String: Any],
            let _data = _userInfo["data"] as? [String: Any],
            let _mobileFriendlyUrl = _data["mobileFriendlyUrl"] as? String {
            
        } else if let _mobileFriendlyUrl = data["mobileFriendlyUrl"] as? String {
            
        }
        
        REiosHandler.getNotification()?.setNotificationAction(response: response)
    }
}

extension UIApplication {
    
    class func topViewController1(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController1(controller: navigationController.visibleViewController)
        }
        if
            let tabController = controller as? UITabBarController,
            let selected = tabController.selectedViewController {
            return topViewController1(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController1(controller: presented)
        }
        return controller
    }
    
}
