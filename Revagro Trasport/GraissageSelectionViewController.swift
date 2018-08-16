//
//  GraissageSelectionViewController.swift
//  Revagro Trasport
//
//  Created by apple on 13/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

protocol GraissageViewControllerDelegate: class {
    func didApplyLingeOne(_ value: String)
    func didApplyLingeTwo(_ value: String)
    func didApplyCompass(_ value: String)
}

class GraissageSelectionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class GraissageSelectionViewController: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var arrData = [String]()
    var titleOnTop = String()
    var selectedIndexPath = -1
    var selectedItem = ""
    var graissageDelegate: GraissageViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "1"), style: .plain, target: self, action: #selector(leftButtonClick))
        self.navigationItem.leftBarButtonItem = leftItem
        self.saveBtn.layer.cornerRadius = 10
        self.title = self.titleOnTop
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- LEFT BUTTON PRESSED
    @objc func leftButtonClick(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if self.titleOnTop == "Select Ligne1" {
            graissageDelegate?.didApplyLingeOne(self.selectedItem)
        } else if self.titleOnTop == "Select Ligne2" {
            graissageDelegate?.didApplyLingeTwo(self.selectedItem)
        } else {
            graissageDelegate?.didApplyCompass(self.selectedItem)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension GraissageSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraissageSelectionCell", for: indexPath) as! GraissageSelectionCell
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
        self.tableView.reloadData()
    }
}
