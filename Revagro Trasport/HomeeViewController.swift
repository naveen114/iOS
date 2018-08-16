//
//  HomeeViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 13/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Firebase
import FirebaseAuth

struct btnTitles {
    var btnOne:String = ""
    var btnTwo:String = ""
    var btnThree:String = ""
    var btnFour:String = ""
}

class HomeeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var assignmentTypeTextField: UITextField!
    @IBOutlet weak var mileageTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var vehicleNumberTextField: UITextField!
    @IBOutlet weak var pauseTextField: UITextField!
    @IBOutlet weak var startShiftBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var arrAssignmentType: [String] = ["Granuals", "Cement", "Entretien"]
    var arrDriverName = [String]()
    var arrPause:[String] = ["Reason1", "Reason1", "Reason1"]
    var arrStrucherData: [btnTitles] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todayDate = formatter.string(from: date)
        self.dateTextField.text = todayDate
//        pauseTextField.dropDownMode = .textPicker
//        pauseTextField.itemList = arrPause
//        driverNameTextField.dropDownMode = .textPicker
//        driverNameTextField.itemList = arrDriverName
//        assignmentTypeTextField.dropDownMode = .textPicker
//        assignmentTypeTextField.itemList = arrAssignmentType
        // Do any additional setup after loading the view.
        self.assignmentTypeTextField.addTarget(self, action: #selector(assignmentTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.driverNameTextField.addTarget(self, action: #selector(driverNameTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.pauseTextField.addTarget(self, action: #selector(pauseReasonTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        
        self.checkIfUserIsLoggedIn()
    }
    
    
    func designUI() {
        let revealController = SWRevealViewController()
        revealController.tapGestureRecognizer()
        revealController.panGestureRecognizer()
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Home"
        startShiftBtn.layer.cornerRadius = 10
    }
  
    //MARK:- ASSIGNMENT TEXTFIELD PRESSED
    @IBAction func assignmentTextFieldAction(_ textFiled: UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        controller.selectionDelegate = self
        controller.arrAssignmentType = arrAssignmentType
        controller.titleOnTop = "Select Assignment"
        let nav = UINavigationController.init(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
    }
    
    //MARK:- DRIVER NAME TEXTFIELD PRESSED
    @IBAction func driverNameTextFieldAction(_ textFiled: UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        controller.selectionDelegate = self
        controller.arrAssignmentType = arrDriverName
        controller.titleOnTop = "Select Driver"
        let nav = UINavigationController.init(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
    }
    
    //MARK:- REASON TEXTFIELD PRESSED
    @IBAction func pauseReasonTextFieldAction(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        controller.selectionDelegate = self
        controller.arrAssignmentType = arrPause
        controller.titleOnTop = "Select Reason"
        let nav = UINavigationController.init(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:- START SHIFT BUTTON PRESSED
    @IBAction func startShifBtnPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as! HomeCGViewController
        let granuals = StartShift.init(btnOne: "POINTAGE", btnTwo: "BADGE LIGNE", btnThree: "CHANGER LIGNE", btnFour: "DECHARGER")
        vc.startShift = granuals
        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if driverNameTextField.selectedItem == ""{
//            AppUtils.showAlert(title: "Alert", message: "Plaese select driver name", viewController: self)
//        }else if assignmentTypeTextField.selectedItem == ""{
//            AppUtils.showAlert(title: "Alert", message: "Please select Assignment type", viewController: self)
//        }else if mileageTextField.text == ""{
//            AppUtils.showAlert(title: "Alert", message: "Please add mileage", viewController: self)
//        }
//        else if (assignmentTypeTextField.selectedItem == "Cement"){
//        let vc:HomeCGViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as! HomeCGViewController
//            let cement = StartShift.init(btnOne: "ARRIVAGE STOCK", btnTwo: "CHARGER", btnThree: "ARRIVAGE CAVE", btnFour: "DECHARGER")
//            vc.startShift = cement
//
//
//        self.navigationController?.pushViewController(vc, animated: true)
//        }else if (assignmentTypeTextField.selectedItem == "Granuals"){
//            let vc:HomeCGViewController = storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as!HomeCGViewController
//        let granuals = StartShift.init(btnOne: "POINTAGE", btnTwo: "BADGE LIGNE", btnThree: "CHANGER LIGNE", btnFour: "DECHARGER")
//            vc.startShift = granuals
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else if (assignmentTypeTextField.selectedItem == "Entretien"){
//            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//
    }
    
    func checkIfUserIsLoggedIn() {
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        if userId != nil {
            ref.child("users").observe(.value, with: { (snapshots) in
                if snapshots.exists() {
                    guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
                    for eachSnap in snapshot {
                        guard let userDict = eachSnap.value as? Dictionary<String,AnyObject> else { return }
                        if let fullName = userDict["full_name"] as? String {
                            self.arrDriverName.append(fullName)
                        }
                    }
                }
            })
        }
    }
}

// MARK:- HOMEEVIEWCONTROLLER CUSTOM DELEGATE
extension HomeeViewController: HomeeViewControllerDelegate {
    func didApplyDriverName(_ value: String) {
        self.driverNameTextField.text = value
    }
    
    func didApplyAssignmentType(_ value: String) {
        self.assignmentTypeTextField.text = value
    }

    func didApplyPause(_ value: String) {
        self.pauseTextField.text = value
    
    }
}
