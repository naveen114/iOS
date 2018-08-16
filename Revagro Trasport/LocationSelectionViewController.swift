//
//  LocationSelectionViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 09/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

protocol PointageViewControllerDelegate: class {
    func didApplyLoadLocation(_ value: String)
    func didApplyLooseLocation(_ value: String)
    func didApplyCaliber(_ value: String)
}

class LocationsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
}

class LocationSelectionViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var arrAssignedData = [String]()
    var titleOnTop = String()
    var selectedIndexPath = -1
    var selectedItem = ""
    var locationDelegate: PointageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "1"), style: .plain, target: self, action: #selector(leftButtonClick))
        self.navigationItem.leftBarButtonItem = leftItem
        self.title = self.titleOnTop
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func leftButtonClick(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if self.titleOnTop == "Load Location" {
            locationDelegate?.didApplyLoadLocation(self.selectedItem)
        } else if self.titleOnTop == "Loose Location" {
            locationDelegate?.didApplyLooseLocation(self.selectedItem)
        } else {
            locationDelegate?.didApplyCaliber(self.selectedItem)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationSelectionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAssignedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell", for: indexPath) as! LocationsCell
        
        cell.nameLabel.text = arrAssignedData[indexPath.row]
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        
        if indexPath.row == selectedIndexPath {
            cell.nameLabel.backgroundColor = RevagroColors.LABEL_BACKGROUND_COLOR
            cell.nameLabel.textColor = UIColor.white
        } else {
            cell.nameLabel.backgroundColor = UIColor.groupTableViewBackground
            cell.nameLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        selectedItem = self.arrAssignedData[indexPath.row]
        self.tableView.reloadData()
    }
}
