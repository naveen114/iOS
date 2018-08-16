//
//  CardansViewController.swift
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

class CardansCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
}

class CardansViewController: UIViewController {
    
    @IBOutlet weak var tabeVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrName:[String] = ["Cardan 1", "Cardan 2", "Cardan 3"]
    var arrImg:[UIImage] = [#imageLiteral(resourceName: "uncheck"), #imageLiteral(resourceName: "uncheck"), #imageLiteral(resourceName: "uncheck")]
    var ref:DatabaseReference!
    var date = String()
    var status = String()
    var arrStatus:[Bool] = [false,false,false]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        tabeVieww.register(UINib.init(nibName: "XibTableViewCell", bundle: nil), forCellReuseIdentifier: "XibTableViewCell")
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
        self.title = "Cardans"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        
        saveBtn.layer.cornerRadius = 10
    }
    
    //MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
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
        
        let cardansData:[String:Any] = ["cardan1":self.arrStatus[0],
                                        "cardan2":self.arrStatus[1],
                                        "cardan3":self.arrStatus[2]]
                                        
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_CARDAN).setValue(cardansData){(error,databaseRef) in
            
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
extension CardansViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardansCell", for: indexPath) as! CardansCell
        //cardanCell.nameBtn.setTitle(arrName[indexPath.row], for: UIControlState())
//        cardanCell.checkUnchekBtn.tag = indexPath.row
//        cardanCell.checkUnchekBtn.addTarget(self, action: #selector(checkUncheckBtnPressed(_:)), for: .touchUpInside)
        cell.nameLabel.text = arrName[indexPath.row]
        cell.nameLabel.clipsToBounds = true
        cell.nameLabel.layer.cornerRadius = 10
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CardansCell = tableView.cellForRow(at: indexPath) as! CardansCell
        if cell.nameLabel.backgroundColor == UIColor.groupTableViewBackground{
            cell.nameLabel.backgroundColor = RevagroColors.LABEL_BACKGROUND_COLOR
            cell.nameLabel.textColor = UIColor.white
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(true, at: indexPath.row)
        }else{
            cell.nameLabel.backgroundColor = UIColor.groupTableViewBackground
            cell.nameLabel.textColor = UIColor.black
            self.arrStatus.remove(at: indexPath.row)
            self.arrStatus.insert(true, at: indexPath.row)
        }
    }
}
