//
//  ShiftHistoryViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ShiftCell:UITableViewCell{
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
}

class ShiftHeaderCell: UITableViewCell {
    @IBOutlet weak var headerDateLbl: UILabel!
}

class ShiftHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableVieww: UITableView!
    
    var ref: DatabaseReference!
    var arrDays = [String]()
    var setDates = Set<String>()
    var arrDates = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        fetchData()
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DESIGN UI
    func designUI() {
        let revealController = revealViewController()
        revealController?.tapGestureRecognizer().isEnabled = true
        revealController?.panGestureRecognizer().isEnabled = true
        revealController?.delegate = self
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    //MARK:- FETCH DATA FROM FIREBASE
    func fetchData() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_START_SHIFT).child(userID ?? "").observe(.value, with: { (snapshots) in
            if snapshots.exists() {
                print(snapshots)
                guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
                for child in snapshot {
                    if let dictionary = child.value as? [String: AnyObject] {
                        if let date = dictionary["date"] as? String {
                            self.setDates.insert(AppUtils.convertDate(date))
                        }
                    }
                }
                self.arrDates = Array(self.setDates)
                for i in 0..<self.arrDates.count {
                    let date = self.arrDates[i]
                    self.arrDays.append(AppUtils.convertDay(date))
                    self.arrDates = self.arrDates.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                }
                self.tableVieww.reloadData()
                HUD.hide()
            }
        })
    }
    
    //MARK:- FETCH DATA FROM FIREBASE SORTED BY DATE
    func fetch() {
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_START_SHIFT).child(uid!).queryOrdered(byChild: "date").observe(.value) { (snap) in
            print(snap)
            guard let snapshot = snap.children.allObjects as? [DataSnapshot] else { return }
            var valueSorted: [DataSnapshot] = [DataSnapshot]()
            var i: Int = snapshot.count
            while i > 0 {
                i = i - 1
                valueSorted.append(snapshot[i])
                print(valueSorted)
            }
            for child in snapshot {
                print(snapshot)
                print(child)
                
                
            }
                
            
        }
    }
}


//MARK:- EXTENSION OF TABLE VIEW
extension ShiftHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftCell = tableView.dequeueReusableCell(withIdentifier: "ShiftCell") as! ShiftCell
        
        shiftCell.dateLbl.text = arrDates[indexPath.row]
        shiftCell.dayLbl.text = arrDays[indexPath.row]
        
        
        return shiftCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "ShiftHeaderCell") as! ShiftHeaderCell
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM,yyyy"
        headerCell.headerDateLbl.text = formatter.string(from: date)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShiftsViewController") as! ShiftsViewController
        vc.selectedDate = self.arrDates[indexPath.row]
        vc.selectedDay = self.arrDays[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- EXTENSION OF REVEAL VIEW CONTROLLER
extension ShiftHistoryViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.view.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = true
        }
    }
}
