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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Button action methods
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
    @IBAction func locationBtnClicked(sender:UIButton) {
        // Pass current location from location manager
        // For example we are sending static values
       // REiosHandler.updateLocation(lat: "13.1234567", long: "87.123456")
        REiosHandler.resulticksAPNSLocalNotification(title: "Welcome to Resulticks", body: "Welcome to Resulticks subtitle")
    }
    @IBAction func customEventBtnClicked(sender:UIButton){
        REiosHandler.addEvent(eventName: "Purchased", data: ["productId": 44, "price": 999].description)
    }
    @IBAction func getNotificationBtnClicked(sender:UIButton){
        // Navigating screen using direct segue
    }
}

class CustomNavController : UINavigationController {
    
    let lblcount = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addNavigationbarCustomView();
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCountLabel), name: NSNotification.Name(rawValue: "unread"), object: nil)
    }
    
    private func addNavigationbarCustomView() {
        
        let viewContainer = UIView()
        viewContainer.autoresizingMask = .flexibleWidth
        viewContainer.frame = CGRect(x: self.view.frame.size.width-100, y: 8, width: 125, height: 30)
        self.navigationBar.addSubview(viewContainer)
        
        let btnNotification = UIButton(type: .custom)
        btnNotification.frame = CGRect(x: 40, y: 0, width: 25, height: 25)
        btnNotification.setBackgroundImage(UIImage.init(named: "bellNew.png"), for: .normal)
        btnNotification.setBackgroundImage(UIImage.init(named: "bellNew.png"), for: .highlighted)
        viewContainer.addSubview(btnNotification)
        
        //updateNotificationCountLabel(notification:nil)
        lblcount.backgroundColor = UIColor.init(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
        
        lblcount.font = UIFont.boldSystemFont(ofSize: 12)
        lblcount.textAlignment = NSTextAlignment.center
        lblcount.layer.cornerRadius = 9
        lblcount.layer.masksToBounds = true
        lblcount.textColor = UIColor.white
        viewContainer.addSubview(lblcount)
        
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func updateNotificationCountLabel(notification : Notification?) {
        
        var lblWidth:Float = 0.0
        var lblHeight:Float = 0.0
        
        if let _notification = notification, let count = _notification.object as? Int {
            
            print("notification : \(String(describing: _notification.object))")
            
            DispatchQueue.main.async {
                
                if count == 0 {
                    self.lblcount.isHidden = true
                } else {
                    self.lblcount.isHidden = false
                }
                
                if count < 10 {
                    lblWidth = 18.0
                    lblHeight = 18.0
                }
                else if count < 100 {
                    lblWidth = 18.0
                    lblHeight = 20.0
                }
                else if count < 1000 {
                    lblWidth = 27.0
                    lblHeight = 20.0
                }
                
                self.lblcount.frame = CGRect(x: 50, y: -7, width: Int(lblWidth), height: Int(lblHeight))
                self.lblcount.text = "\(count)"
            }
        }
    }
}

