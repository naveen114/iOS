//
//  TuyauxHydraulicsViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 07/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD

class HydraulicCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class TuyauxHydraulicsViewController: UIViewController {
    
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ref:DatabaseReference!
    var status = String()
    var arrStatus:[Bool] = [false]
    var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        tableVieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Tuyaux hydraulics"
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
        let usreid = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let hydraulicsData: [String:Any] = ["hydraulics": self.arrStatus[0]]
                                            
        
        ref.child(Constants.NODE_MAINTENANCE).child(usreid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_HYDRAULICS_TUYAUX).setValue(hydraulicsData){(error,databaseRef) in
            
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

extension TuyauxHydraulicsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HydraulicCell", for: indexPath) as! HydraulicCell
        
        cell.nameLabel.text = "Tuyaux hydraulics"
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
//        cell.checkUnchekBtn.tag = indexPath.row
//        cell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckBtnPressed(_:)), for: .touchUpInside)
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:HydraulicCell = tableView.cellForRow(at: indexPath) as! HydraulicCell
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
