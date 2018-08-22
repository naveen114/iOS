//
//  ShiftsViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 13/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ShiftsHeaderCell: UITableViewCell {
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var assignmentLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mileageLbl: UILabel!
    @IBOutlet weak var numberOfVehicleLbl: UILabel!
}
class ShiftsCell: UITableViewCell {
    @IBOutlet weak var loadingPlaceLbl: UILabel!
    @IBOutlet weak var looseLocationLbl: UILabel!
    @IBOutlet weak var caliberLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var timeStatusLbl: UILabel!
    @IBOutlet weak var indicatorImage: UIImageView!
}
class ShiftsViewController: UIViewController {
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    var cell: Bool = false
    var selectedIndexPathSection = -1
    var ref: DatabaseReference!
    var selectedDate = ""
    var selectedDay = ""
    var arrData = [[String: AnyObject]]()
    var arrHeaderData = [String]()
    var arrCellData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        fetchData()
    }
    
    func designUI() {
        lblDate.text = selectedDate
        lblDay.text = selectedDay
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Shifts"
    }
    
    
    
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(Constants.NODE_START_SHIFT).child(userID ?? "")
        let db = ref.queryOrdered(byChild: "date").queryEqual(toValue: AppUtils.convertDateFormat(selectedDate))
        db.observe(.value, with: { (snapshots) in
            if snapshots.exists() {
                print(snapshots)
                guard let snapshot = snapshots.children.allObjects as? [DataSnapshot] else { return }
                for child in snapshot {
                    if let dictionary = child.value as? [String: AnyObject] {
                        self.arrData.append(dictionary)
                    }
                }
                print(self.arrData)
                self.tableVieww.reloadData()
                HUD.hide()
            }
        })
    }
}

extension ShiftsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedIndexPathSection == section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftsCell", for: indexPath) as! ShiftsCell
//        if let range = arrFuelData[indexPath.row].range(of: " : ") {
//            let upperbound = arrFuelData[indexPath.row][range.upperBound...]
//            print(upperbound)
//            let attributedStr = NSMutableAttributedString.init(string: arrFuelData[indexPath.row])
//            let colorAttributes = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
//            let location = NSRange.init(location: arrFuelData[indexPath.row].count - upperbound.count, length: upperbound.count)
//            attributedStr.addAttributes(colorAttributes, range: location)
//            cell.fieldNameLbl.attributedText = attributedStr
//        }
        let dict = self.arrData[indexPath.section]
        if let loadLocation = dict["load_location"] as? String {
            let str = NSMutableAttributedString(string: "Loading Place : " + loadLocation)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 16, length: loadLocation.count)
            str.addAttributes(colorAttribute, range: range)
            cell.loadingPlaceLbl.attributedText = str
        }
        if let looseLocation = dict["loose_location"] as? String {
            let str = NSMutableAttributedString(string: "Loose Place : " + looseLocation)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 14, length: looseLocation.count)
            str.addAttributes(colorAttribute, range: range)
            cell.looseLocationLbl.attributedText = str
        }
        if let caliber = dict["caliber"] as? String {
            let str = NSMutableAttributedString(string: "Caliber : " + caliber)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 10, length: caliber.count)
            str.addAttributes(colorAttribute, range: range)
            cell.caliberLbl.attributedText = str
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShiftsHeaderCell") as! ShiftsHeaderCell
        let dict = self.arrData[section]
        if let assignment = dict["assignment_type"] as? String{
            let str = NSMutableAttributedString(string: "Assignment : " + assignment)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 13, length: assignment.count)
            str.addAttributes(colorAttribute, range: range)
            cell.assignmentLbl.attributedText = str
        }
        if let time = dict["time"] as? String {
            let str = NSMutableAttributedString(string: "Time : " + time)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 7, length: time.count)
            str.addAttributes(colorAttribute, range: range)
            cell.timeLbl.attributedText = str
        }
        if let mileage = dict["mileage"] as? Int {
            cell.mileageLbl.text = "Mileage : \(mileage)"
            let str = NSMutableAttributedString(string: "Mileage : " + "\(mileage)")
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 10, length: String(mileage).count)
            str.addAttributes(colorAttribute, range: range)
            cell.mileageLbl.attributedText = str
        }
        if let number = dict["vehicle_number"] as? String {
            cell.numberOfVehicleLbl.text = "Number : \(number)"
            let str = NSMutableAttributedString(string: "Number : " + number)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR]
            let range = NSRange(location: 9, length: number.count)
            str.addAttributes(colorAttribute, range: range)
            cell.numberOfVehicleLbl.attributedText = str
            
        }
        cell.headerButton.tag = section
        cell.headerButton.addTarget(self, action: #selector(showCell), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrData.count
    }

    @objc func showCell(sender:UIButton) {
        if(selectedIndexPathSection == sender.tag) {
            selectedIndexPathSection = -1
        } else {
            print("button tag : \(sender.tag)")
            selectedIndexPathSection = sender.tag
        }
        //reload tablview
        UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.transitionCrossDissolve , animations: {
            self.tableVieww.reloadData()
        }, completion: nil)
    }
}
