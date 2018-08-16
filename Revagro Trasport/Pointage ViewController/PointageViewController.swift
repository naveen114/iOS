//
//  PointageViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 14/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import FirebaseDatabase
import Firebase

protocol changeBtnImageDelegate {
    func btnImage(btnImage:UIImage)
}

class locationsModel {
    var location1: String = ""
    var location2: String = ""
    var location3: String = ""
    
    init(location1:String, location2:String, location3:String) {
        self.location1 = location1
        self.location2 = location2
        self.location3 = location3
    }
}

class PointageViewController: UIViewController {
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var loadingPaceTextField: UITextField!
    @IBOutlet weak var loosePlaceTextField: UITextField!
    @IBOutlet weak var caliberTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calliberViewTopConstraint: NSLayoutConstraint!
    
    var ref: DatabaseReference!
    var databaseHandler:DatabaseHandle?
    var arrLocationKeys:[String] = []
    
    var arrLoadingLocation = [String]()
    var arrLooseLocation = [String]()
    var arrCaliber = [String]()
    var arrRawMaterial = [String]()
    var arrData:[String]  = []
    
    var placeHolder: String! = ""
    var delegate: changeBtnImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designUI()
        caliberTextField.placeholder = placeHolder
        
        self.loadingPaceTextField.addTarget(self, action: #selector(loadLocationTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.loosePlaceTextField.addTarget(self, action: #selector(looseLocationTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.caliberTextField.addTarget(self, action: #selector(caliberTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        
        fetchLoadLocations()
        fetchLooseLocations()
        fetchCaliberData()
        fetchMaterialData()
    }
    
    //MARK:- LOAD LOCATION TEXTFIELD PRESSED
    @IBAction func loadLocationTextFieldAction(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LocationSelectionViewController") as! LocationSelectionViewController
        controller.locationDelegate = self
        controller.arrAssignedData = self.arrLoadingLocation
        controller.titleOnTop = "Load Location"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- LOOSE LOCATION TEXTFIELD PRESSED
    @IBAction func looseLocationTextFieldAction(_ textFiled:UITextField ) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LocationSelectionViewController") as! LocationSelectionViewController
        controller.locationDelegate = self
        controller.arrAssignedData = self.arrLooseLocation
        controller.titleOnTop = "Loose Location"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- CALIBER TEXTFIELD PRESSED
    @IBAction func caliberTextFieldAction(_ textFiled:UITextField ) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LocationSelectionViewController") as! LocationSelectionViewController
        controller.locationDelegate = self
        if caliberTextField.placeholder == "Caliber" {
            controller.arrAssignedData = self.arrCaliber
            controller.titleOnTop = "Caliber"
        } else {
            controller.arrAssignedData = self.arrRawMaterial
            controller.titleOnTop = "Raw Material"
        }
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func designUI() {
        self.title = "Pointage"
        saveBtn.layer.cornerRadius = 10
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        calliberViewTopConstraint.priority = UILayoutPriority.init(250)
        saveButtonTopConstraint.priority = UILayoutPriority.init(999)
        calliberViewTopConstraint.constant = 0
        saveButtonTopConstraint.constant = 182
    }
    
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        if (loadingPaceTextField.text != "" && loosePlaceTextField.text != "" && caliberTextField.text != ""){
        let sendedImage = UIImage.init(named: "64")
            delegate?.btnImage(btnImage: sendedImage!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func fetchLoadLocations() {
        ref = Database.database().reference()
        
        ref.child(Constants.NODE_LOCTION).child(Constants.NODE_LOAD_LOCATION).observe(.value) { (snapshots) in
            print(snapshots)
            guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
            for child in snapshot {
                if let dictionary = child.value as? [String: AnyObject] {
                    if let loadLocation = dictionary["location"] as? String{
                        self.arrLoadingLocation.append(loadLocation)
                    }
                }
            }
        }
    }
    
    //MARK:- FETCH LOOSE LOCATIONS FROM FIREBASE
    func fetchLooseLocations() {
        ref = Database.database().reference()
        
        ref.child(Constants.NODE_LOCTION).child(Constants.NODE_LOOSE_LOCATION).observe(.value) { (snapshots) in
            print(snapshots)
            guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
            for child in snapshot {
                if let dictionary = child.value as? [String: AnyObject] {
                    if let looseLocation = dictionary["location"] as? String {
                        self.arrLooseLocation.append(looseLocation)
                    }
                }
            }
        }
    }
    
    //MARK:- FETCH CALIBER FROM FIREBASE
    func fetchCaliberData(){
        ref = Database.database().reference()
        
        ref.child("caliber").observe(.value) { (snapshots) in
            print(snapshots)
            guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
            for child in snapshot {
                if let dictionary = child.value as? [String: AnyObject] {
                    if let caliber = dictionary["caliber"] as? String {
                        self.arrCaliber.append(caliber)
                    }
                }
            }
        }
    }
    
    //MARK:- FETCH MATERIAL FROM FIREBASE
    func fetchMaterialData(){
        ref = Database.database().reference()
        
        ref.child("material").observe(.value) { (snapshots) in
            print(snapshots)
            guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
            for child in snapshot {
                if let dictionary = child.value as? [String: AnyObject] {
                    print(dictionary)
                    if let material = dictionary["material"] as? String {
                        self.arrRawMaterial.append(material)
                    }
                }
            }
        }
    }
}

extension PointageViewController: PointageViewControllerDelegate {
    func didApplyLoadLocation(_ value: String) {
        self.loadingPaceTextField.text = value
        self.showCaliber()
    }
    
    func didApplyLooseLocation(_ value: String) {
        self.loosePlaceTextField.text = value
        self.showCaliber()
    }
    
    func didApplyCaliber(_ value: String) {
        self.caliberTextField.text = value
    }
    
    func showCaliber() {
        if (loosePlaceTextField.text != "" && loadingPaceTextField.text != "") {
            innerView.isHidden = false
            calliberViewTopConstraint.priority = UILayoutPriority.init(999)
            saveButtonTopConstraint.priority = UILayoutPriority.init(250)
            calliberViewTopConstraint.constant = 102
            saveButtonTopConstraint.constant = 262
        } else {
            innerView.isHidden = true
            calliberViewTopConstraint.priority = UILayoutPriority.init(250)
            saveButtonTopConstraint.priority = UILayoutPriority.init(999)
            calliberViewTopConstraint.constant = 0
            saveButtonTopConstraint.constant = 182
        }
    }
}
