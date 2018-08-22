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
import PKHUD

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
    var arrPause:[String] = ["To have dinner", "To take rest", "Other reason"]
    var arrStrucherData: [btnTitles] = []
    var ref: DatabaseReference!
    var licencePlateNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        //validationsOnView()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        self.mileageTextField.keyboardType = .numberPad
        self.assignmentTypeTextField.addTarget(self, action: #selector(assignmentTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.driverNameTextField.addTarget(self, action: #selector(driverNameTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.pauseTextField.addTarget(self, action: #selector(pauseReasonTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        
        self.checkIfUserIsLoggedIn()
    }
    
    func validationsOnView(){
        if (self.driverNameTextField.text == "" || self.assignmentTypeTextField.text == "" || self.mileageTextField.text == "") {
            self.timeTextField.text = ""
            self.dateTextField.text = ""
            self.vehicleNumberTextField.text = ""
        } else {
            let date = Date()
            let formatter = DateFormatter()
            let timeFormatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            timeFormatter.dateFormat = "HH:mm a"
            let todayDate = formatter.string(from: date)
            let currentTime = timeFormatter.string(from: date)
            self.dateTextField.text = todayDate
            self.timeTextField.text = currentTime
            self.vehicleNumberTextField.text = self.licencePlateNumber
        }
    }
    
    //MARK:- DESIGN UI
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
    
    //MARK:- TEXT FIELD DELEGATE METHOD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.assignmentTypeTextField {
            textField.resignFirstResponder()
        } else if textField == self.driverNameTextField {
            textField.resignFirstResponder()
        } else if textField == self.pauseTextField {
            textField.resignFirstResponder()
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       self.validationsOnView()
    }
    
    
    
    //MARK:- START SHIFT BUTTON PRESSED
    @IBAction func startShifBtnPressed(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as! HomeCGViewController
//        let granuals = StartShift.init(btnOne: "POINTAGE", btnTwo: "BADGE LIGNE", btnThree: "CHANGER LIGNE", btnFour: "DECHARGER")
//        vc.startShift = granuals
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if driverNameTextField.text == ""{
            HUD.flash(.label("Please select driver name"), onView: view, delay: 2.0) { (true) in
                
            }
        }else if assignmentTypeTextField.text == ""{
            HUD.flash(.label("Please select assignment type"), onView: view, delay: 2.0) { (true) in
                
            }
        }else if mileageTextField.text == ""{
            HUD.flash(.label("Please add mileage"), onView: view, delay: 2.0) { (true) in
                
            }
        }
        else if (assignmentTypeTextField.text == "Cement"){
        let vc:HomeCGViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as! HomeCGViewController
            let cement = StartShift.init(btnOne: "ARRIVAGE STOCK", btnTwo: "CHARGER", btnThree: "ARRIVAGE CAVE", btnFour: "DECHARGER")
            let cementData = StartShiftData.init(driverName: self.driverNameTextField.text ?? "", assignmentType: self.assignmentTypeTextField.text ?? "", mileage: Int(mileageTextField.text ?? "0") ?? 0, date: self.dateTextField.text ?? "", time: self.timeTextField.text ?? "", number: self.vehicleNumberTextField.text ?? "", reason: self.pauseTextField.text ?? "")
            vc.startShiftData = cementData
            vc.startShift = cement
        self.navigationController?.pushViewController(vc, animated: true)
        }else if (assignmentTypeTextField.text == "Granuals"){
            let vc:HomeCGViewController = storyboard?.instantiateViewController(withIdentifier: "HomeCGViewController") as!HomeCGViewController
        let granuals = StartShift.init(btnOne: "POINTAGE", btnTwo: "BADGE LIGNE", btnThree: "CHANGER LIGNE", btnFour: "DECHARGER")
            let granualsData = StartShiftData.init(driverName: self.driverNameTextField.text ?? "", assignmentType: self.assignmentTypeTextField.text ?? "", mileage: Int(mileageTextField.text ?? "0") ?? 0, date: self.dateTextField.text ?? "", time: self.timeTextField.text ?? "", number: self.vehicleNumberTextField.text ?? "", reason: self.pauseTextField.text ?? "")
            vc.startShiftData = granualsData
            vc.startShift = granuals
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (assignmentTypeTextField.text == "Entretien"){
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
            saveData()
            Helper.setPREF(Strings.END_SHIFT, key: UserDefaults.PREF_SHIFT_NAME)
            self.navigationController?.pushViewController(vc, animated: true)
        }


    }
    
    func checkIfUserIsLoggedIn() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
//        let token = Auth.auth().currentUser?.refreshToken
//        print(token)
        
//        /////////
//        let currentUser = Auth.auth().currentUser
//        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//            if let error = error {
//                // Handle error
//                return;
//            }
//
//            print(idToken)
//        }
//        ////
        if userId != nil {
            ref.child("users").observe(.value, with: { (snapshots) in
                if snapshots.exists() {
                    guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
                    for eachSnap in snapshot {
                        guard let userDict = eachSnap.value as? Dictionary<String,AnyObject> else { return }
                        if let fullName = userDict["full_name"] as? String {
                            self.arrDriverName.append(fullName)
                        }
                        if let number = userDict["licence_number"] as? String {
                            self.licencePlateNumber = number
                        }
                    }
                }
                HUD.hide()
            })
        }
    }
    
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        let data:[String: AnyObject] = ["driver_name": self.driverNameTextField.text as AnyObject,
                                        "assignment_type": self.assignmentTypeTextField.text as AnyObject,
                                        "mileage": Int(self.mileageTextField.text!) as AnyObject,
                                        "date": self.dateTextField.text as AnyObject,
                                        "time": self.timeTextField.text as AnyObject,
                                        "vehicle_number": self.vehicleNumberTextField.text as AnyObject,
                                        "pause_reason": self.pauseTextField.text as AnyObject,
                                        "caliber": "" as AnyObject,
                                        "load_location": "" as AnyObject,
                                        "loose_location": "" as AnyObject,
                                        "comment": "" as AnyObject]
        
        ref.child(Constants.NODE_START_SHIFT).child(userid!).childByAutoId().setValue(data) { (error, databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
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
