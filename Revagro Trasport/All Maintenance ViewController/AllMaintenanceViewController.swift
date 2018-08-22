//
//  AllMaintenanceViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

class MaintenanceCell:UITableViewCell{
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: UILabel!
}


struct maintenaceItems {
    var itemImage:UIImage
    var itemName:String
    var arrowImage:UIImage
    
    init(itemImage:UIImage, itemName:String, arrowImage:UIImage) {
        self.itemImage = itemImage
        self.arrowImage = arrowImage
        self.itemName = itemName
    }
}

class AllMaintenanceViewController: UIViewController {
    
    
    var maintenanceContent:[maintenaceItems] = [maintenaceItems(itemImage: #imageLiteral(resourceName: "fuel"), itemName: "Fuel", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "liquidLevel"), itemName: "Level of the liquid", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Carroseries"), itemName: "Carroseries", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Pneus"), itemName: "Pneus", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Feux"), itemName: "Feux", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Lames"), itemName: "Lames", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Verrins"), itemName: "Verrins", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Tuyaux hydraulics"), itemName: "Tuyaux hydraulics", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Graissage"), itemName: "Graissage", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Cardans"), itemName: "Cardans", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Cleaning the truck"), itemName: "Cleaning the truck", arrowImage: #imageLiteral(resourceName: "Right Arrow")), maintenaceItems(itemImage: #imageLiteral(resourceName: "Cabin"), itemName: "Cabin", arrowImage: #imageLiteral(resourceName: "Right Arrow")),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gesture to hide reveal view controller on view
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    func designUI(){
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.brown
        navBar?.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

extension AllMaintenanceViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let maintenanceCell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell" + String(indexPath.row))
        let maintenanceCell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell") as! MaintenanceCell
      
        
        maintenanceCell.iconImage.image = maintenanceContent[indexPath.row].arrowImage
        maintenanceCell.iconName.text = maintenanceContent[indexPath.row].itemName
        maintenanceCell.iconImage.image = maintenanceContent[indexPath.row].itemImage
        maintenanceCell.innerView.layer.cornerRadius = 5
        return maintenanceCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            let vc = storyboard?.instantiateViewController(withIdentifier: "FuelViewController") as! FuelViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 1){
            let vc = storyboard?.instantiateViewController(withIdentifier: "LiquidLevelViewController") as! LiquidLevelViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if (indexPath.row == 2){
            let vc = storyboard?.instantiateViewController(withIdentifier: "CarroSeriesViewController") as! CarroSeriesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 3){
            let vc = storyboard?.instantiateViewController(withIdentifier: "PneusViewController") as! PneusViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 4){
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeuxViewController") as! FeuxViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 5){
            let vc = storyboard?.instantiateViewController(withIdentifier: "LamesViewController") as! LamesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 6){
            let vc = storyboard?.instantiateViewController(withIdentifier: "VerinsViewController") as! VerinsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 7){
            let vc = storyboard?.instantiateViewController(withIdentifier: "TuyauxHydraulicsViewController") as! TuyauxHydraulicsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 8){
            let vc = storyboard?.instantiateViewController(withIdentifier: "GraissageViewController")as! GraissageViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 9){
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardansViewController") as! CardansViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 10){
            let vc = storyboard?.instantiateViewController(withIdentifier: "TruckCleaningViewController") as! TruckCleaningViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if (indexPath.row == 11){
            let vc = storyboard?.instantiateViewController(withIdentifier: "CabinViewController") as! CabinViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}




