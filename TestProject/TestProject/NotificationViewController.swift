//
//  NotificationInboxViewController.swift
//  VisionBank
//
//  Created by Interakt on 2/6/17.
//  Copyright © 2017 Interakt. All rights reserved.
//

import UIKit
import Alamofire
//import Mixpanel
import UserNotifications
import REIOSSDK
import SDWebImage

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableNotificationInbox: UITableView!
    
    var noteJson:[Any] = []
    var arry:[Any] = []
    let cellId = "cell"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(NotificationViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        // Setting up navigationbar item
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(red: 5/255, green: 78/255, blue: 167/255, alpha: 1.0)
        self.navigationItem.hidesBackButton = false
        
        // Getting notification list from REIOSSDK
        noteJson = REiosHandler.getNotificationList()
        
        // Setting up tableview
        tableNotificationInbox.tableFooterView = UIView()
        tableNotificationInbox.delegate = self
        tableNotificationInbox.dataSource = self
        tableNotificationInbox.addSubview(refreshControl)
        tableNotificationInbox.register(NotificationCustomCell.self, forCellReuseIdentifier: "Cell")
        tableNotificationInbox.reloadData()
        
        // Clear notification tray once user read notification
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Update notification count on bell icon
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unread"), object: 0)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        noteJson = REiosHandler.getNotificationList()
        tableNotificationInbox.reloadData()
        refreshControl.endRefreshing()
    }
    
    // Tableview delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteJson.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCustomCell") as! NotificationCustomCell
        let notificationData = noteJson[indexPath.row] as! [String:Any]
        if let title = notificationData["title"]{
            cell.title.text = title as? String;
        }
        
        if let subtitle = notificationData["body"] as? String {
            if(!subtitle.isEmpty){
                cell.body.text = subtitle
            } else if let _subtitle = notificationData["subtitle"] as? String {
                cell.body.text = _subtitle;
            }
        }
        
        if let image_url = notificationData["notificationImageUrl"] as? String {
            
            guard let imageUrl = URL(string: image_url) else { return cell }
            
            cell.notificationImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "starFilled.png"), options: .continueInBackground, context: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            REiosHandler.deleteNotificationListWith(dict: noteJson[indexPath.row] as! [String : Any])
            noteJson = REiosHandler.getNotificationList()
            tableNotificationInbox.reloadData()
        }
    }
}

class NotificationCustomCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}




















