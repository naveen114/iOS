//
//  LiquidLevelViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class LiquidLevelViewController: UIViewController {
    
    @IBOutlet weak var engineOilTextField: UITextField!
    @IBOutlet weak var liquidCoolingTextField: UITextField!
    @IBOutlet weak var hydraulicsOilTextField: UITextField!
    @IBOutlet weak var directionalOilTextField: UITextField!
    @IBOutlet weak var washingMachineTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var ref:DatabaseReference!
    var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Level of the liquid"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
    }
    
   //MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        textFiedValidations()
    }
    
    // MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let liquidLevelDetails:[String:Any] = ["engine_oil":self.engineOilTextField.text ?? "",
                                               "hydraulic_oil":self.hydraulicsOilTextField.text ?? "",
                                               "liquid_cooling":self.liquidCoolingTextField.text ?? "",
                                               "directional_oil":self.directionalOilTextField.text ?? "",
                                               "washing_machine":self.washingMachineTextField.text ?? ""]
            
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_LIQUID_LEVEL).setValue(liquidLevelDetails){(error,databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            AppUtils.showAlertandPopViewController(title: "Alert", message: "Saved succesfully", viewController: self)
        }
    }
    
    // MARK:- TEXTFIELD VALIDATIONS
    func textFiedValidations(){
        if ((self.engineOilTextField.text?.isEmpty)! || (self.liquidCoolingTextField.text?.isEmpty)! || (hydraulicsOilTextField.text?.isEmpty)! || (self.directionalOilTextField.text?.isEmpty)! || (self.washingMachineTextField.text?.isEmpty)!){
            
            AppUtils.showAlert(title: "Alert", message: "All fields required", viewController: self)
        
        }else{
            
            saveData()
        }
    }
    
    
}
