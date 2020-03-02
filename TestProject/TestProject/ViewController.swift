//
//  ViewController.swift
//  TestProject
//
//  Created by Rajaram on 26/02/20.
//  Copyright © 2020 Rajaram. All rights reserved.
//

import UIKit
import REIOSSDK
import Firebase
class ViewController: UIViewController {

     var noteJson:[Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    @IBAction func registerBtnClicked(sender:UIButton){
        if let _token = UserDefaults.standard.value(forKey: "token") as? String {
                      
                       let userData:[String: Any] = [
                           "userUniqueId": "9941107038",
                           "name": "bhuvanesh",
                           "age": "29",
                           "email": "admin@gmail.com" ,
                           "phone": "9941107038",
                           "gender": "male",
                           "token": _token,
                           "profileUrl":"profile_url"
                       ]
            print(userData)
            REiosHandler.sdkRegistrationWithDict(params: userData);
           
            
        }
        
    }
    @IBAction func locationBtnClicked(sender:UIButton){
          REiosHandler.updateLocation(lat: "13.1234567", long: "87.123456")
    }
    @IBAction func customEventBtnClicked(sender:UIButton){
         REiosHandler.addEvent(eventName: "User custom event", data: nil)
    }
    @IBAction func addNewNotification(sender:UIButton) {
//        REiosHandler.resulticksAPNSLocalNotification(title: "Welcome to Resulticks", body: "Hi Welcome to Resulticks.")
        REiosHandler.unreadNotificationCount(onSuccess: { (count) in
            DispatchQueue.main.async(execute: {
                self.showAlerView(message: "\(count)")
            })
            
        }) { (count) in
            DispatchQueue.main.async(execute: {
                 self.showAlerView(message: "No Notification is triggered")
            })
           
        }
    }
    @IBAction func getNotificationBtnClicked(sender:UIButton){
        noteJson = REiosHandler.getNotificationList()
        showAlerView(message: noteJson.description);
    }
    func showAlerView(message:String){
        let alert = UIAlertController(title: "Notification List", message:message, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
                self.dismiss(animated: true, completion: nil)
            }
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func deteteNotificationBtnClicked(sender:UIButton){
        if(noteJson.count > 0){
            REiosHandler.deleteNotificationListWith(dict: noteJson.last as! [String : Any])
        }
        
    }
    @IBAction func screenTrackingBtnClicked(sender:UIButton){
        REiosHandler.setScreenName(screenName: "Dashboard")
    }

}

