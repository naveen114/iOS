//
//  MenuViewController.swift
//
//
//  Created by ATPL on 04/06/18.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


struct menuItems {
    var menuImage:UIImage
    var menuData:String
    
    init(menuImage:UIImage, menuData:String) {
        self.menuData = menuData
        self.menuImage = menuImage
    }
}

class TableViewCell:UITableViewCell{
    
    
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var menuName: UILabel!
}

class MenuHeaderCell:UITableViewCell{
    
    
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tabelVieww: UITableView!
    
    class func instantiateVC() -> MenuViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        return controller
    }
    
    
    //var menuContent:[menuItems] = [menuItems(menuImage:#imageLiteral(resourceName: "46"), menuData:"Shift"), menuItems(menuImage:#imageLiteral(resourceName: "47"), menuData:"Profile"),menuItems(menuImage:#imageLiteral(resourceName: "48"), menuData:"Notification"), menuItems(menuImage:#imageLiteral(resourceName: "49"), menuData:"Syncronization"), menuItems(menuImage:#imageLiteral(resourceName: "14"), menuData:"Shift History"), menuItems(menuImage:#imageLiteral(resourceName: "51"), menuData:"Maintance"), menuItems(menuImage:#imageLiteral(resourceName: "52"), menuData:"Log Out")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelVieww.tableFooterView = UIView()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


extension MenuViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //return menuContent.count
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" + String(indexPath.row))
        //cell.menuName.text = menuContent[indexPath.row].menuData
        //cell.menuImage.image = menuContent[indexPath.row].menuImage
      
        
        return cell ?? TableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCell") as! MenuHeaderCell
        
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6{
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "LOG OUT", style: .default, handler: { (action:UIAlertAction) in
                do {
                    try Auth.auth().signOut()
                    
                    
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }))
            alert.addAction(UIAlertAction(title: "NOT NOW", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

}

