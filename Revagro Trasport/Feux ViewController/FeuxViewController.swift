//
//  FeuxViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 07/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class FeuxViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var avGaucheTextField: UITextField!
    @IBOutlet weak var arDroitTextField: UITextField!
    @IBOutlet weak var arrGaucheTextField: UITextField!
    @IBOutlet weak var arrDroitTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ref: DatabaseReference!
    var date = String()
    
    var arrAVGauche = ["position", "Route", "gr Position", "travail b", "clignoteur", "the travail b","encombre"]
    var arrAVDroit = ["position", "route", "gr position", "travail h", "clignoteur", "the travail h", "encombre"]
    var arrARRGauche = ["the route", "anti broullard", "stop", "position", "clignoteur", "de travail", "encombre"]
    var arrARRDroit = ["the route", "stop", "position", "clignoteur", "the travail", "encombre"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designUI()
        self.avGaucheTextField.addTarget(self, action: #selector(avGaucheTextFieldAction), for: UIControlEvents.editingDidBegin)
        self.arDroitTextField.addTarget(self, action: #selector(arDroittextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.arrGaucheTextField.addTarget(self, action: #selector(arrGaucheTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        self.arrDroitTextField.addTarget(self, action: #selector(arrDroitTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
    }
    
    //MARK:- DESIGN UI
    func designUI() {
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Feux"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
    }
    
    //MARK:- TEXT FIELD RESIGN FIRST RESPONDER DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:- AV GAUCHE TEXTFIELD PRESSED
    @IBAction func avGaucheTextFieldAction(_ textFiled:UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeuxSelectionViewController") as! FeuxSelectionViewController
        controller.feuxDelegate = self
        controller.arrData = self.arrAVGauche
        controller.titleOnTop = "Select AV Gauche"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    //////////////////////////
    
    ///////////////////////////
    //MARK:- AR DROIT TEXTFIELD PRESSED
    @IBAction func arDroittextFieldAction(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeuxSelectionViewController") as! FeuxSelectionViewController
        controller.feuxDelegate = self
        controller.arrData = self.arrAVDroit
        controller.titleOnTop = "Select AV Droit"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- ARR GAUCHE TEXTFIELD PRESSED
    @IBAction func arrGaucheTextFieldAction(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeuxSelectionViewController") as! FeuxSelectionViewController
        controller.feuxDelegate = self
        controller.arrData = self.arrARRGauche
        controller.titleOnTop = "Select ARR Gauche"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- ARR DROIT TEXTFIELD PRESSED
    @IBAction func arrDroitTextFieldAction(_ textFiled:UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "FeuxSelectionViewController") as! FeuxSelectionViewController
        controller.feuxDelegate = self
        controller.arrData = self.arrARRDroit
        controller.titleOnTop = "Select ARR Droit"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- BACK BUTTON PRESSED
    @objc func backButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData() {
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let fuexData:[String: Any] = ["av_gauche":self.avGaucheTextField.text ?? "",
                                     "ar_droit":self.arDroitTextField.text ?? "",
                                     "arr_gauche":self.arrGaucheTextField.text ?? "",
                                     "arr_droit":self.arrDroitTextField.text ?? ""]
                                     
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_FEUX).setValue(fuexData){(error,databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            AppUtils.showAlertandPopViewController(title: "Alert", message: "Saved succesfully", viewController: self)
        }
    }
    
    //MARK:- TEXTFIELD VALIDATIONS
    func validations() {
        if self.avGaucheTextField.text == nil || self.arDroitTextField.text == nil || self.arrGaucheTextField.text == nil || self.arrDroitTextField.text == nil{
            
            AppUtils.showAlert(title: "Alert", message: "Please select all fields", viewController: self)
            
        }else{
            saveData()
        }
    }
    
    //MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        validations()
    }
}

// MARK: - FEUXVIEWCONTROLLER DELEGATE
extension FeuxViewController: FeuxViewControllerDelegate {
    func didApplyAVGauche(_ value: String) {
        self.avGaucheTextField.text = value
    }
    
    func didApplyAVDroit(_ value: String) {
        self.arDroitTextField.text = value
    }
    
    func didApplyARRGauche(_ value: String) {
        self.arrGaucheTextField.text = value
    }
    
    func didApplyARRDroit(_ value: String) {
        self.arrDroitTextField.text = value
    }
}
