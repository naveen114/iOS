//
//  FuelViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class FuelViewController: UIViewController {
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tankForRefuelingTextField: UITextField!
    @IBOutlet weak var fuelQuantityRefueledTextField: UITextField!
    @IBOutlet weak var tankAfterRefuelingTextField: UITextField!
    
    var ref:DatabaseReference!
    var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- DESIGN UI
    func designUI(){
        
        //let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Fuel"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
    }
    
    // MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        validations()
    }
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let fuelDetails:[String:Any] = ["tank_for_refueling" : self.tankForRefuelingTextField.text ?? "",
                                        "fuel_quantity_refueled" : self.fuelQuantityRefueledTextField.text ?? "",
                                        "tank_after_refueling" : self.tankAfterRefuelingTextField.text ?? ""]
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_FUEL).setValue(fuelDetails){(error,databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            AppUtils.showAlertandPopViewController(title: "Alert", message: "Saved succesfully", viewController: self)
        }
    }
    
    // MARK:- TEXTFIELD VALIDATIONS
    func validations(){
        if ((self.tankForRefuelingTextField.text?.isEmpty)! || (self.fuelQuantityRefueledTextField.text?.isEmpty)! || (self.tankAfterRefuelingTextField.text?.isEmpty)!){
            
            AppUtils.showAlert(title: "Alert", message: "All field required", viewController: self)
            print("empty")
        }else{
            saveData()
        }
    }
    
}
