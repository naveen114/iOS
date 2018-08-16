//
//  LamesViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 07/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import PKHUD


class lamesCell:UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
}

class LamesViewController: UIViewController {
    
    var arrLamesData:[String] = ["AV gauche", "AV droit", "ARR gauche", "ARR droit"]
    var arrStatus:[Bool] = [false,false,false,false]
    var date = String()
    
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        tableVieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Lames"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
    }
    
    //MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SAVE DATA IN FIREBASE
    func saveData(){
        HUD.show(.progress)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let lamesData:[String:Any] = ["av_gauche":self.arrStatus[0] ,
                                      "av_droit":self.arrStatus[1] ,
                                      "arr_gauche":self.arrStatus[2] ,
                                      "arr_droit":self.arrStatus[3]]
                                      
        
        
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_LAMES).setValue(lamesData){(error,databaseRef) in
            
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
extension LamesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLamesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lamesCell", for: indexPath) as! lamesCell
        cell.nameLabel.text = arrLamesData[indexPath.row]
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        //cell.nameLbl.text = arrLamesData[indexPath.row]
//        cell.checkUnchekBtn.tag = indexPath.row
//        cell.checkUnchekBtn.addTarget(self, action: #selector(checkUnchekBtnPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:lamesCell = tableView.cellForRow(at: indexPath) as! lamesCell
        
        
        if cell.nameLabel.backgroundColor == UIColor.groupTableViewBackground {
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
