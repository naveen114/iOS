//
//  StopShiftViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 02/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class StopShiftViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var hideBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var dashcamBtn: UIButton!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    
    var arrReasons = ["Reason1","Reason2","Reason3","Reason4"]
    var ref: DatabaseReference!
    
    class func instantiateVC() -> StopShiftViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StopShiftViewController") as! StopShiftViewController
        return controller
    }
    
    //MARK:- DELEGATE OF TEXT FIELD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:- SHOW STOP SHOFT VIEW CONTROLLER
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
    
    //MARK:- FUNC SHOW VIEW CONTROLLER
    public func showVC(){
        showStopShiftVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        reasonTextField.addTarget(self, action: #selector(reasonTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TEXT FIELD ACTION
    @IBAction func reasonTextFieldAction(_ textFiled:UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReasonSelectionViewController") as! ReasonSelectionViewController
        controller.reasonDelegate = self
        controller.arrData = self.arrReasons
        controller.titleOnTop = "Select Reason"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        innerView.layer.borderWidth = 1
        dashcamBtn.layer.borderWidth = 1
        dashcamBtn.backgroundColor = UIColor(red: 21/255.0, green: 92/255.0, blue: 161/255.0, alpha: 1)
        dashcamBtn.layer.cornerRadius = 10
        dashcamBtn.tintColor = UIColor.white
        minuteTextField.keyboardType = .numberPad
    }
    
    //MARK:- FUNCTION HIDE VIEW
    func hideViewOnClick(){
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK:- HIDE VIEW BUTTON ACTION
    @IBAction func hideViewBtnPressed(_ sender: Any) {
        hideViewOnClick()
    }
    
    func validationOnView(){
        if self.minuteTextField.text == "" {
            HUD.flash(.label("Please add number of minutes"), onView: view, delay: 2.0) { (true) in
                
            }
        } else if self.reasonTextField.text == "" {
            HUD.flash(.label("Please choose reason of waiting"), onView: view, delay: 2.0) { (true) in
                
            }
        } else {
            updateData()
        }
    }
    
    
    func updateData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let newPostRef = ref.child("pause_reason").childByAutoId()
        let newPostKey = newPostRef.key
        let updateUserData:[String: Any] = ["start_shift/pause_reason/\(newPostKey)": true, "pause_reason /\(newPostKey)": ["minutes": self.minuteTextField.text ?? "", "reason": self.reasonTextField.text ?? ""]]
        ref.updateChildValues(updateUserData) { (error, databaseRef) in
            if let error = error {
                print(error.localizedDescription)
                AppUtils.showAlert(title: "Alert", message: error.localizedDescription, viewController: self)
            }
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Saved"), onView: self.view, delay: 1.0, completion: { (true) in
                print("saved")
                self.hideViewOnClick()
            })
        }
    }
    
    
    @IBAction func dashcamButtonPressed(_ sender: UIButton) {
        self.validationOnView()
    }
    
}


extension StopShiftViewController: StopShiftViewControllerDelegate {
    func didApplyReason(_ value: String) {
        self.reasonTextField.text = value
    }
    
    
}




