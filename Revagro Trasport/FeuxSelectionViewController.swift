//
//  FeuxSelectionViewController.swift
//  Revagro Trasport
//
//  Created by apple on 10/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

protocol FeuxViewControllerDelegate: class {
    func didApplyAVGauche(_ value: String)
    func didApplyAVDroit(_ value: String)
    func didApplyARRGauche(_ value: String)
    func didApplyARRDroit(_ value: String)
}

class FeuxCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

class FeuxSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var arrData = [String]()
    var titleOnTop = String()
    var selectedIndexPath = -1
    var selectedItem = ""
    var feuxDelegate: FeuxViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
        saveBtn.layer.cornerRadius = 10
        let leftItem = UIBarButtonItem(image: UIImage.init(named: "1"), style: .plain, target: self, action: #selector(leftButtonClick))
        self.navigationItem.leftBarButtonItem = leftItem
        self.title = self.titleOnTop
        self.tableView.reloadData()
    }

    //MARK:- LEFT BUTTON PRESSED
    @objc func leftButtonClick(){
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if self.titleOnTop == "Select AV Gauche" {
            feuxDelegate?.didApplyAVGauche(self.selectedItem)
        } else if self.titleOnTop == "Select AV Droit" {
            feuxDelegate?.didApplyAVDroit(self.selectedItem)
        } else if self.titleOnTop == "Select ARR Gauche" {
            feuxDelegate?.didApplyARRGauche(self.selectedItem)
        } else {
            feuxDelegate?.didApplyARRDroit(self.selectedItem)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension FeuxSelectionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeuxCell", for: indexPath) as! FeuxCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        selectedItem = self.arrData[indexPath.row]
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
