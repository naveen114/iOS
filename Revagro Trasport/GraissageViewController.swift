//
//  GraissageViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 08/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class GraissageLabelCell:UITableViewCell{
    @IBOutlet weak var nameLbl: UILabel!
}

class GraissageTextFieldCell:UITableViewCell{
    @IBOutlet weak var graissageTextField: UITextField!
}

class GraissageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tabeVieww: UITableView!
    
    var button = UIButton()
    var ref:DatabaseReference!
    var status = String()
    var arrStatus = [false, false, false]
    var arrValues = ["", "", ""]
    var date = String()
    
    var nameArray:[String] = ["Crochet bene" ,"Bras securite gauche" ,"Bras securite droit" ]
    var arrPlaceholders:[String] = ["ligne 1", "ligne 2", "compas"]
    var arrImg:[UIImage] = [ #imageLiteral(resourceName: "uncheck"), #imageLiteral(resourceName: "uncheck"), #imageLiteral(resourceName: "uncheck")]
    var arrLigne1:[String] = ["1","2","3","4","5","6","7","8"]
    var arrLigne2:[String] = ["1","2","3","4","5","6"]
    var arrCompas:[String] = ["bas gauche", "bas droit", "environmental gauche 1 and 2", "milieu droit 1 and 2" , "haut gauche 1,2 and 3" ,"haut droit 1,2 and 3", "vert port gauche 1 and 2", "verrin port droit 1 and 2" , "verrin central haute gauche" , "verrin central haut droit", "verrin central bass gauche ", "verrin central bass droit", "axes ARR benne gauche", "axes ARR benne droit", "porte avant gauche" ,"porte avant droit", "ouventure calandre"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
    }
    
    //MARK:- TEXT FIELD RESIGN FIRST RESPONDER DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Graissage"
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
    

    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let graissageData: [String: Any] = ["crochet_bene":self.arrStatus[0],
                                            "bras_securite_gauche":self.arrStatus[1],
                                            "bras_securite_droit":self.arrStatus[2],
                                            "ligne 1":self.arrValues[0].isEmpty ? "No Data" : self.arrValues[0],
                                            "ligne 2":self.arrValues[1].isEmpty ? "No Data" : self.arrValues[1],
                                            "compas":self.arrValues[2].isEmpty ? "No Data" : self.arrValues[2]]
        
        print(graissageData)
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_GRAISSAGE).setValue(graissageData){(error, databaseRef) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Saved"), onView: self.view, delay: 1.0, completion: { (true) in
                print("saved")
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        saveData()
    }
    
    //MARK:- AV GAUCHE TEXTFIELD ACTION 1
    @IBAction func grissageTextFieldAction1(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GraissageSelectionViewController") as! GraissageSelectionViewController
        controller.graissageDelegate = self
        controller.arrData = self.arrLigne1
        controller.titleOnTop = "Select Ligne1"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- AV GAUCHE TEXTFIELD ACTION 2
    @IBAction func grissageTextFieldAction2(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GraissageSelectionViewController") as! GraissageSelectionViewController
        controller.graissageDelegate = self
        controller.arrData = self.arrLigne2
        controller.titleOnTop = "Select Ligne2"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- AV GAUCHE TEXTFIELD ACTION 3
    @IBAction func grissageTextFieldAction3(_ textFiled:UITextField ){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "GraissageSelectionViewController") as! GraissageSelectionViewController
        controller.graissageDelegate = self
        controller.arrData = self.arrCompas
        controller.titleOnTop = "Select Compas"
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - UITABLEVIEW METHODS
extension GraissageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraissageLabelCell", for: indexPath) as! GraissageLabelCell
            cell.nameLbl.text = nameArray[indexPath.row]
            cell.nameLbl.layer.cornerRadius = 10
            cell.nameLbl.clipsToBounds = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraissageTextFieldCell") as! GraissageTextFieldCell
            cell.graissageTextField.placeholder = arrPlaceholders[indexPath.row]
            cell.graissageTextField.text = arrValues[indexPath.row]
            
            if (indexPath.row == 0) {
                cell.graissageTextField.addTarget(self, action: #selector(grissageTextFieldAction1(_:)), for: UIControlEvents.editingDidBegin)
            } else if (indexPath.row == 1) {
                cell.graissageTextField.addTarget(self, action: #selector(grissageTextFieldAction2(_:)), for: UIControlEvents.editingDidBegin)
            } else if (indexPath.row == 2){
                cell.graissageTextField.addTarget(self, action: #selector(grissageTextFieldAction3(_:)), for: UIControlEvents.editingDidBegin)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:GraissageLabelCell = tableView.cellForRow(at: indexPath) as! GraissageLabelCell
        if cell.nameLbl.backgroundColor == UIColor.groupTableViewBackground{
            cell.nameLbl.backgroundColor = RevagroColors.LABEL_BACKGROUND_COLOR
            cell.nameLbl.textColor = UIColor.white
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(true, at: indexPath.row)
        } else {
            cell.nameLbl.backgroundColor = UIColor.groupTableViewBackground
            cell.nameLbl.textColor = UIColor.black
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(false, at: indexPath.row)
        }
    }
}

// MARK: - GRAISSAGE VIEW CONTROLLER DELEGATE
extension GraissageViewController: GraissageViewControllerDelegate {
    func didApplyLingeOne(_ value: String) {
        arrValues.remove(at: 0)
        arrValues.insert(value, at: 0)
        self.tabeVieww.reloadData()
    }
    
    func didApplyLingeTwo(_ value: String) {
        arrValues.remove(at: 1)
        arrValues.insert(value, at: 1)
        self.tabeVieww.reloadData()
    }
    
    func didApplyCompass(_ value: String) {
        arrValues.remove(at: 2)
        arrValues.insert(value, at: 2)
        self.tabeVieww.reloadData()
    }
}
