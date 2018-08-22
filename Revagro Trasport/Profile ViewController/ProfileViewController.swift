//
//  ProfileViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 04/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD

class ProfileCell: UITableViewCell {
    @IBOutlet weak var profileLogoImg: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var profileDataLbl: UILabel!
}

class HeaderCell: UITableViewCell {
    @IBOutlet weak var nameOfUserLbl: UILabel!
    @IBOutlet weak var licenceNumberLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
}

struct profileItems {
    var profileLogo:UIImage
    var profileFieldName:String
    var profileFieldData:String
    
    init(profileLogo:UIImage, profileFieldName:String, profileFieldData:String) {
        self.profileLogo = profileLogo
        self.profileFieldName = profileFieldName
        self.profileFieldData = profileFieldData
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tablevieww: UITableView!
    
    var ref: DatabaseReference!
    var licenseNumber = String()
    var name = String()
    
    class func instantiateVC() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        return controller
    }
    
    var profileContent = [profileItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfileData()
        designUI()
    }
    
    //MARK:- DESIGN UI
    func designUI() {
        let revealController = revealViewController()
        revealController?.tapGestureRecognizer().isEnabled = true
        revealController?.panGestureRecognizer().isEnabled = true
        revealController?.delegate = self
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- FETCH USER PROFILE FROM FIREBASE
    func fetchUserProfileData() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userId = "eETg0p487OZZpEtI7tuH2drTeBG2"
        
        ref.child("users").child(userId).observe(.value) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let email = dictionary["email"] as? String{
                    self.profileContent.append(profileItems.init(profileLogo: #imageLiteral(resourceName: "profileLogo"), profileFieldName: "EMAIL", profileFieldData: email))
                }
                if let dob = dictionary["dob"] as? String {
                    self.profileContent.append(profileItems.init(profileLogo: #imageLiteral(resourceName: "DOB"), profileFieldName: "DOB", profileFieldData: dob))
                }
                if let address = dictionary["address"] as? String {
                    self.profileContent.append(profileItems.init(profileLogo: #imageLiteral(resourceName: "address"), profileFieldName: "ADDRESS", profileFieldData: address))
                }
                if let name = dictionary["full_name"] as? String{
                    self.name = name
                }
                if let licenceNumber = dictionary["licence_number"] as? String{
                    self.licenseNumber = "License Number \(licenceNumber)"
                }
            }
            HUD.hide()
            self.tablevieww.reloadData()
        }
    }
}

//MARK:- EXTENSION OF TABLEVIEW
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        profileCell.profileLogoImg.image = profileContent[indexPath.row].profileLogo
        profileCell.profileNameLbl.text = profileContent[indexPath.row].profileFieldName
        profileCell.profileDataLbl.text = profileContent[indexPath.row].profileFieldData
        
        return profileCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.profileImage.layer.cornerRadius = 80
        headerCell.profileImage.layer.borderWidth = 3
        headerCell.profileImage.layer.borderColor = UIColor.white.cgColor
        
        headerCell.licenceNumberLbl.text = licenseNumber
        headerCell.nameOfUserLbl.text = name
        
        return headerCell
    }
}

//MARK:- EXTENSION OF REVEAL VIEW CONTROLLER
extension ProfileViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            self.view.isUserInteractionEnabled = false
        } else {
            self.view.isUserInteractionEnabled = true
        }
    }
}
