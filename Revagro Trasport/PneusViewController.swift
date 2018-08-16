//
//  PneusViewController.swift
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
import FirebaseStorage
import PKHUD

class PneusHeaderCell:UITableViewCell{
    
    @IBOutlet weak var uoloadBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    
    override func draw(_ rect: CGRect) {
        let viewBorder = CAShapeLayer()
        viewBorder.strokeColor = UIColor.blue.cgColor
        viewBorder.lineDashPattern = [4, 4]
        viewBorder.frame = self.innerView.bounds
        viewBorder.fillColor = nil
        viewBorder.path = UIBezierPath(rect: self.innerView.bounds).cgPath
        self.innerView.layer.addSublayer(viewBorder)
    }
}

class PneusCell:UITableViewCell{
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var gaucheTextField: UITextField!
    @IBOutlet weak var droitTextField: UITextField!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var lblHeadingHeightConstraint: NSLayoutConstraint!
}

class PneusViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrTextFiledData:[String] = ["DM 03","DM 04","LRDU","Fires","Autre"]
    var arrGauche = ["", "", "", ""]
    var arrDroit = ["", "", "", ""]
    let imagePicker = UIImagePickerController()
    var date = String()
    var image = UIImage()
    var ref:DatabaseReference!
    var storageRef:StorageReference!
    var urls = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designUI()
    }
    
    //MARK:- TEXT FIELD RESIGN FIRST RESPONDER DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //MARK:- DESIGN UI
    func designUI() {
        self.title = "Pneus"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
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
    
     //MARK:- UPLOAD PHOTO BUTTON PRESSED
    @IBAction func uploadTruckAxlePhotoBtnPressed(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker,animated: true, completion: nil)
    }
    
     //MARK:- DESIGN UI
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        uploadMedia()
//        saveData()
    }
    
    //MARK:- AV GAUCHE TEXTFIELD PRESSED
    @IBAction func gaucheTextFieldAction(_ textField: UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PneusSelectionViewController") as! PneusSelectionViewController
        controller.pneusDelegate = self
        controller.arrData = self.arrTextFiledData
        controller.titleOnTop = "Select Gauche"
        controller.itemIndex = textField.tag
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- AV DROIT TEXTFIELD PRESSED
    @IBAction func droitTextFieldAction(_ textField: UITextField) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PneusSelectionViewController") as! PneusSelectionViewController
        controller.pneusDelegate = self
        controller.arrData = self.arrTextFiledData
        controller.titleOnTop = "Select Droit"
        controller.itemIndex = textField.tag
        let navigationController = UINavigationController.init(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- SAVE PHOTOS TO FIREBASE
    func uploadMedia() {
        HUD.show(.progress)
        storageRef = Storage.storage().reference().child("pneus_photos")
        print(self.image.size)
        print(self.image)
        if let uploadData = UIImageJPEGRepresentation(self.image, 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                self.storageRef.downloadURL(completion: { (url, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    let photoUrl = url?.absoluteString
                    self.urls = photoUrl ?? ""
                    print(self.urls)
                    self.saveData()
                })
            }
        }
        
    }
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData() {
        HUD.show(.progress)
         ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let pneusData: [String: Any] = ["1_ess_av_gauche": self.arrGauche[0],
                                      "1_ess_av_droit": self.arrDroit[0],
                                      "2_ess_av_gauche": self.arrGauche[1],
                                      "2_ess_av_droit": self.arrDroit[1],
                                      "1_ess_ar_gauche": self.arrGauche[2],
                                      "1_ess_ar_droit": self.arrDroit[2],
                                      "2_ess_ar_droit_gauche": self.arrGauche[3],
                                      "2_ess_ar_droit_droit": self.arrDroit[3],
                                      "photo_url": self.urls]
        
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_PNEUS).setValue(pneusData) {(error, databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            AppUtils.showAlert(title: "Alert", message: "Saved succesfully", viewController: self)
        }
    }
}

extension PneusViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pneusCell = tableView.dequeueReusableCell(withIdentifier: "PneusCell") as! PneusCell
        
        pneusCell.gaucheTextField.tag = indexPath.row
        pneusCell.droitTextField.tag = indexPath.row
        pneusCell.gaucheTextField.addTarget(self, action: #selector(gaucheTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        pneusCell.droitTextField.addTarget(self, action: #selector(droitTextFieldAction(_:)), for: UIControlEvents.editingDidBegin)
        
        if (indexPath.row == 0) {
            pneusCell.headingLbl.isHidden = false
            pneusCell.headingLbl.text = "1 ess. AV:"
        } else if (indexPath.row == 1) {
            pneusCell.headingLbl.isHidden = false
            pneusCell.headingLbl.text = "2 ess. AV:"
        } else if (indexPath.row == 2) {
            pneusCell.headingLbl.isHidden = false
            pneusCell.headingLbl.text = "1 ess. AR:"
        } else if (indexPath.row == 3) {
            pneusCell.headingLbl.isHidden = true
            pneusCell.headingLbl.text = nil
            pneusCell.droitTextField.placeholder = "Droit Droit"
            pneusCell.gaucheTextField.placeholder = "Droit Gauche"
            pneusCell.lblHeadingHeightConstraint.constant = 0
        }
        pneusCell.gaucheTextField.text = self.arrGauche[indexPath.row]
        pneusCell.droitTextField.text = self.arrDroit[indexPath.row]
        
        return pneusCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "PneusHeaderCell") as! PneusHeaderCell
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
}

// MARK: - UIIMAGEPICKER CONTROLLER DELEGATE
extension PneusViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PNEUSSELECTION VIEW CONTROLLER DELEGATE
extension PneusViewController: PneusViewControllerDelegate {
    func didApplyGauche(_ value: String, _ index: Int) {
        self.arrGauche.remove(at: index)
        self.arrGauche.insert(value, at: index)
        self.tableView.reloadData()
    }
    
    func didApplyDroit(_ value: String, _ index: Int) {
        self.arrDroit.remove(at: index)
        self.arrDroit.insert(value, at: index)
        self.tableView.reloadData()
    }
}
