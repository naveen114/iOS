//
//  SelectionViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 08/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

protocol HomeeViewControllerDelegate: class {
    func didApplyDriverName(_ value: String)
    func didApplyAssignmentType(_ value: String)
    func didApplyPause(_ value: String)
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
}

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrAssignmentType = [String]()
    var titleOnTop = String()
    var selectedIndexPath = -1
    var selectedItem = ""
    var selectionDelegate: HomeeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
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
        if self.titleOnTop == "Select Driver" {
            selectionDelegate?.didApplyDriverName(self.selectedItem)
        } else if self.titleOnTop == "Select Assignment" {
            selectionDelegate?.didApplyAssignmentType(self.selectedItem)
        } else {
            selectionDelegate?.didApplyPause(self.selectedItem)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAssignmentType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        cell.dataLabel.text = arrAssignmentType[indexPath.row]
        cell.dataLabel.layer.cornerRadius = 10
        cell.dataLabel.clipsToBounds = true
        
        if indexPath.row == selectedIndexPath {
            cell.dataLabel.backgroundColor = RevagroColors.LABEL_BACKGROUND_COLOR
            cell.dataLabel.textColor = UIColor.white
        } else {
            cell.dataLabel.backgroundColor = UIColor.groupTableViewBackground
            cell.dataLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        selectedItem = self.arrAssignmentType[indexPath.row]
        self.tableView.reloadData()
    }
}
