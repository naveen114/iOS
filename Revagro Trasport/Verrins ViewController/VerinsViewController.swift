//
//  VerinsViewController.swift
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

class VerrinsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
}

class VerinsViewController: UIViewController {
    
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ref:DatabaseReference!
    var date = String()
    var arrStatus:[Bool] = [false,false,false]
    
    var arrName:[String] = ["Central Benne", "Port Gauche", "Port Droit" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designUI()
        tableVieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Verrins"
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.date = dateFormatter.string(from: getDate)
        
        let verrinsData:[String:Any] = ["central_benne":self.arrStatus[0],
                                        "port_gauche":self.arrStatus[1],
                                        "port_droit":self.arrStatus[2]]
                                        
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_VERRINS).setValue(verrinsData){(error,databaseRef) in
            
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
    
}

extension VerinsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerrinsCell", for: indexPath) as! VerrinsCell
        cell.nameLabel.text = arrName[indexPath.row]
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        
        
//        cell.checkUnchekBtn.tag = indexPath.row
//        cell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckPressed(_:)), for: .touchUpInside)
//
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
        let cell:VerrinsCell = tableView.cellForRow(at: indexPath) as! VerrinsCell
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
