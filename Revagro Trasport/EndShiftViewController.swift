//
//  EndShiftViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 18/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class EndShiftViewController: UIViewController {
    
    class func instantiateVC() -> EndShiftViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EndShiftViewController") as! EndShiftViewController
        return controller
    }
    
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var endShiftBtn: UIButton!
    @IBOutlet weak var hideBtn: UIButton!
    
    typealias alertCompletion = ((Int) -> Void)?
    private var block: alertCompletion?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SHOW END SHIFT VIEW CONTROLLER
    private func showEndShiftVC() {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            //viewWillAppear(true)
            didMove(toParentViewController: topViewController)
        }
    }
    
    //MARK:- SHOW VIEW CONTROLLER WITH COMPLETION BLOCK
    public func showVC(completion: alertCompletion) {
        showEndShiftVC()
        block = completion
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        endShiftBtn.layer.cornerRadius = 10
        endShiftBtn.backgroundColor = UIColor(red: 21/255, green: 92/255, blue: 161/255, alpha: 1)
    }
    
    
    //MARK:- VALIDATIONS ON VIEW
    func validationsOnView(){
        if self.mileageTextField.text == "" {
            HUD.flash(.label("Please add mileage"), onView: view, delay: 2.0) { (true) in
                
            }
        } else {
            updateMileageData()
        }
    }
    
    //MARK:- UPDATE MILEAGE
    func updateMileageData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let newPostRef = ref.child("new_mileage").childByAutoId()
        let newPostKey = newPostRef.key
        let updateMileageData:[String: Any] = ["start_shift/new_mileage/\(newPostKey)": true, "new_mileage/\(newPostKey)": ["mileage":  self.mileageTextField.text ?? ""]]
        ref.updateChildValues(updateMileageData) { (error, databaseref) in
            if let error = error {
                print(error.localizedDescription)
                AppUtils.showAlert(title: "Alert", message: error.localizedDescription, viewController: self)
            }
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Shift completed"), onView: self.view, delay: 1.0, completion: { (true) in
                print("saved")
                
                 self.endShift()
            })
           
        }
        
    }
    
    //MARK:- HIDE SHIFT BUTTON PRESSED
    @IBAction func hideShiftBtnPressed(_ sender: UIButton) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK:- FUNCTION END SHIFT
    func endShift(){
        block!!(0)
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK:- END SHIFT BUTTON PRESSED
    @IBAction func endShiftBtnPressed(_ sender: UIButton) {
       self.validationsOnView()
    }
    
}
