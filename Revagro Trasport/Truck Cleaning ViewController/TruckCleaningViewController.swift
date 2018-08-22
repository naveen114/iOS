//
//  TruckCleaningViewController.swift
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

class TruckCleaningCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class TruckCleaningViewController: UIViewController {
    
    
    @IBOutlet weak var tablevieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrData:[String] = ["CCB", "MAN Barry"]
    var status = String()
    var date = String()
    var arrStatus:[Bool] = [false,false]
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        tablevieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
        // Do any additional setup after loading the view.
    }
    
     //MARK:- DESIGN UI
    func designUI(){
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Nettoyage du camion"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
        
    }
    
    // MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
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
        
        let cleaningData:[String:Any] = ["ccb":self.arrStatus[0],
                                         "man_barry":self.arrStatus[1]]
        
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_CLEANING_TRUCK).setValue(cleaningData){(error,databaseref) in
            
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        saveData()
    }
    
}

extension TruckCleaningViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TruckCleaningCell", for: indexPath) as! TruckCleaningCell
        cell.nameLabel.text = arrData[indexPath.row]
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        //cell.nameBtn.setTitle(arrData[indexPath.row], for: UIControlState())
//        cell.checkUnchekBtn.tag = indexPath.row
//        cell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TruckCleaningCell = tableView.cellForRow(at: indexPath) as! TruckCleaningCell
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
