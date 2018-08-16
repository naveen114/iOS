//
//  CabinViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 08/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class CabinCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class CabinViewController: UIViewController {
    
    
    @IBOutlet weak var tabeVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var nameArray:[String] = ["Essuies glace" ,"Temoins securites" ,"Proprete" ,"Nettoyage filter cabin" ,"Nettoyage filter moteur"]
    
    
    var ref:DatabaseReference!
    var date = String()
    var arrStatus:[Bool] = [false,false,false,false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        tabeVieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Cabin"
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
  
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let cabinData:[String:Any] = ["essuies_glace":self.arrStatus[0],
                                      "temoins_securites":self.arrStatus[1],
                                      "proprete":self.arrStatus[2],
                                      "nettoyage_filter_cabin":self.arrStatus[3],
                                      "nettoyage_filter_moteur":self.arrStatus[4]]
                                      
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_CABIN).setValue(cabinData){(error,databaseRef) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            AppUtils.showAlertandPopViewController(title: "Alert", message: "Saved succesfully", viewController: self)
        }
    }
    
    //MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        saveData()
    }
    
    
}

extension CabinViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CabinCell", for: indexPath) as! CabinCell
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        //        cabinCell.checkUnchekBtn.tag = indexPath.row
        //        cabinCell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckBtnPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CabinCell = tableView.cellForRow(at: indexPath) as! CabinCell
        if cell.nameLabel.backgroundColor == UIColor.groupTableViewBackground{
            cell.nameLabel.backgroundColor = RevagroColors.LABEL_BACKGROUND_COLOR
            cell.nameLabel.textColor = UIColor.white
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(true, at: indexPath.row)
        }else{
            cell.nameLabel.backgroundColor = UIColor.groupTableViewBackground
            cell.nameLabel.textColor = UIColor.black
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(false, at: indexPath.row)
        }
    }
}
