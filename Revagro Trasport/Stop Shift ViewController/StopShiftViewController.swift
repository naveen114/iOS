//
//  StopShiftViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 02/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField

class StopShiftViewController: UIViewController {

    @IBOutlet weak var hideBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var dashcamBtn: UIButton!
    @IBOutlet weak var reasonTextField: IQDropDownTextField!
    @IBOutlet weak var minuteTextField: UITextField!
    
    
    class func instantiateVC() -> StopShiftViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StopShiftViewController") as! StopShiftViewController
        return controller
    }
    
    
    private func showStopShiftVC(){
        
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController{
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil{
                topViewController = topViewController.presentedViewController!
            }
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            //viewWillAppear(true)
            didMove(toParentViewController: topViewController)
        }
    }
    public func showVC(){
     showStopShiftVC()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        reasonTextField.isOptionalDropDown = false
        reasonTextField.itemList = ["Reason1","Reason2","Reason3","Reason4"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func designUI(){
        
        innerView.layer.borderWidth = 1
        dashcamBtn.layer.borderWidth = 1
        dashcamBtn.backgroundColor = UIColor(red: 21/255.0, green: 92/255.0, blue: 161/255.0, alpha: 1)
        dashcamBtn.layer.cornerRadius = 10
        dashcamBtn.tintColor = UIColor.white
    minuteTextField.keyboardType = .numberPad
        
        
    }
 
    @IBAction func hideViewBtnPressed(_ sender: Any) {
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
    }
    
    
}
