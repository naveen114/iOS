//
//  NotificationViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 05/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD


class NotificationCell: UITableViewCell {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var revagroLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var goodsTypeLbl: UILabel!
}

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableVieww: UITableView!
    
    
    var arrAssignmentType:[String] = ["Sent you a cement shift","Sent you a granulates shift","Sent you a entretien shift","Sent you a cement shift","Sent you a granulates shift"]
    var arrTime:[String] = ["39 min ago", "4 hour ago", "6 hour ago", "2 hour ago" , "40 in ago"]
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
    }

    //MARK:- DESIGN UI
    func designUI(){
        let revealController = revealViewController()
        revealController?.tapGestureRecognizer().isEnabled = true
        revealController?.panGestureRecognizer().isEnabled = true
        revealController?.delegate = self
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- EXTENSION OF TABLE VIEW
extension NotificationViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        notificationCell.innerView.layer.borderWidth = 1
        notificationCell.innerView.layer.borderColor = UIColor.lightGray.cgColor
        notificationCell.innerView.layer.cornerRadius = 5
        notificationCell.goodsTypeLbl.text = arrAssignmentType[indexPath.row]
        notificationCell.timeLbl.text = arrTime[indexPath.row]
        return notificationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

//MARK:- EXTENSION OF REVEAL VIEW CONTROLLER
extension NotificationViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.view.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = true
        }
    }
}

