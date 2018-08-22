//
//  SynchronizationViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 05/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase

class SynchronizationViewController: UIViewController {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var synchronizeBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        textLbl.text = "Synchronize your data to our\nserver and access it "
        dateLbl.text = "Last Synced : 05/06/2018 6:53 PM "
        synchronizeBtn.backgroundColor = UIColor(red: 56/255.0, green: 171/255.0, blue: 57/255.0, alpha: 1)
        synchronizeBtn.layer.cornerRadius = 10
        synchronizeBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        
    }
}

//MARK:- EXTENSION OF SWREVEAL VIEW CONTROLLER
extension SynchronizationViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.view.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = true
        }
    }
}
