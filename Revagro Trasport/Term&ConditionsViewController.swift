//
//  Term&ConditionsViewController.swift
//  Revagro Trasport
//
//  Created by apple on 17/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import SafariServices

class Term_ConditionsViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
       openSafariVC()
        
    }

    func openSafariVC() {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.google.com")! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designUI(){
        self.title = "Term & Conditions"
        let revealViewController = SWRevealViewController()
        revealViewController.tapGestureRecognizer()
        revealViewController.panGestureRecognizer()
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
}
