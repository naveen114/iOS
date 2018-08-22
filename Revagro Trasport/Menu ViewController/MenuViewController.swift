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
import SafariServices


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

class MenuViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var tabelVieww: UITableView!
    var selectedIndex = -1
    
    
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}


extension MenuViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell" + String(indexPath.row))
        //cell.menuName.text = menuContent[indexPath.row].menuData
        //cell.menuImage.image = menuContent[indexPath.row].menuImage
        //cell?.backgroundColor = UIColor.black
        cell?.contentView.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 30/255, alpha: 1)
        if selectedIndex == indexPath.row {
            cell?.contentView.backgroundColor = RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR
        }
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
        self.selectedIndex = indexPath.row
        self.tabelVieww.reloadData()
        
        if indexPath.row == 6 {
            let safariVC = SFSafariViewController(url: NSURL(string: "https://www.google.com")! as URL)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        
        if indexPath.row == 7{
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


    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: self.tabelVieww.frame.size.height, width: self.tabelVieww.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.frame.size.width - 100, height: footerView.frame.size.height))
        label.text = "Version 1.1"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 25)
        footerView.addSubview(label)
        footerView.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 30/255, alpha: 1)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

