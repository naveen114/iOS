//
//  PneusSelectionViewController.swift
//  Revagro Trasport
//
//  Created by apple on 13/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

protocol PneusViewControllerDelegate: class {
    func didApplyGauche(_ value: String, _ index: Int)
    func didApplyDroit(_ value: String, _ index: Int)
}

class PneusSelectionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class PneusSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrData = [String]()
    var titleOnTop = String()
    var selectedIndexPath = -1
    var selectedItem = ""
    var itemIndex = 0
    var pneusDelegate: PneusViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleOnTop
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "1"), style: .plain, target: self, action: #selector(leftButtonClick))
        self.navigationItem.leftBarButtonItem = leftItem
        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        print(arrData)
        self.tableView.reloadData()
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
        if self.titleOnTop == "Select Gauche" {
            pneusDelegate?.didApplyGauche(self.selectedItem, itemIndex)
        } else {
            pneusDelegate?.didApplyDroit(self.selectedItem, itemIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension PneusSelectionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PneusSelectionCell", for: indexPath) as! PneusSelectionCell
        cell.nameLabel.layer.cornerRadius = 10
        cell.nameLabel.clipsToBounds = true
        cell.nameLabel.text = arrData[indexPath.row]
        
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
