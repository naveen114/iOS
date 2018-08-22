//
//  ReasonSelectionViewController.swift
//  Revagro Trasport
//
//  Created by apple on 16/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

class ReasonCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}


protocol StopShiftViewControllerDelegate {
    func didApplyReason(_ value: String)
}

class ReasonSelectionViewController: UIViewController {

    var arrData = [String]()
    var titleOnTop = String()
    var reasonDelegate: StopShiftViewControllerDelegate?
    var selectedItem = ""
    var selectedIndexPath = -1
    
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleOnTop
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "1"), style: .plain, target: self, action: #selector(leftButtonClick))
        self.navigationItem.leftBarButtonItem = leftItem
        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        self.saveBtn.layer.cornerRadius = 10
    }
    
    @objc func leftButtonClick(){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        reasonDelegate?.didApplyReason(self.selectedItem)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ReasonSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath) as! ReasonCell
        cell.nameLabel.text = arrData[indexPath.row]
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
        selectedItem = self.arrData[indexPath.row]
        self.tableVieww.reloadData()
    }
    
}






