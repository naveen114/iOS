//
//  ViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 01/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Reachability

class ViewController: UIViewController {
    
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accountLogInLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //let ref:DatabaseReference
    let reachability = Reachability()!
    var ref:DatabaseReference!
    
    class func instantiateVC() -> ViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        return controller
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkReachability()
        designUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func designUI(){
        loginBtn.layer.cornerRadius = 10
        //loginBtn.backgroundColor = UIColor.green
        accountLogInLbl.textColor = UIColor(red: 233/255.0, green: 99/255.0, blue: 8/255.0, alpha: 1)
        loginBtn.backgroundColor = UIColor(red: 56/255.0, green: 171/255.0, blue: 57/255.0, alpha: 1)
    }
    
    func checkReachability(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
//    //MARK:- SAVE DATA TO FIREBASE
//    func saveData(){
//        ref = Database.database().reference()
//
//        let fuelDetails:[String:Any] = ["lat" : "1",
//                                        "lng" :  "1",
//                                        "location" : "1"]
//
//        ref.child(Constants.NODE_LOCTION).child(Constants.NODE_LOAD_LOCATION).childByAutoId().setValue(fuelDetails){(error,databaseRef) in
//            if let error = error{
//                print(error.localizedDescription)
//            }
//            AppUtils.showAlertandPopViewController(title: "Alert", message: "Saved succesfully", viewController: self)
//        }
//    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if driverNameTextField.text == "" && passwordTextField.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please Enter All fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail:driverNameTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil{
                    let revealController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.present(revealController, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Alert", message:  error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }

//            // create new user
//            Auth.auth().createUser(withEmail: self.driverNameTextField.text ?? "", password: passwordTextField.text ?? "") { (user, error) in
//                print(error?.localizedDescription ?? "")
//                print(error.debugDescription)
//                if error == nil{
//                    let revealController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                    self.present(revealController, animated: true, completion: nil)
//                    //self.saveData()
//                }
//            }
        }
    }
    
    
//    func saveData(){
//        ref = Database.database().reference()
//        let userid = Auth.auth().currentUser?.uid
//
//        let userDetails:[String:Any] = [Constants.NODE_EMAIL: "testing@test.com",
//                                        Constants.NODE_FULL_NAME: "Driver",
//                                        Constants.NODE_DOB: "12-24-1990",
//                                        Constants.NODE_ADDRESS: "testing address",
//                                        Constants.NODE_LICENCE_NUMBER: "584342747201",
//                                        Constants.NODE_DEVICETOKEN: InstanceID.instanceID().token() ?? ""]
//
//        self.ref.child(Constants.NODE_USER).child(userid!).child(Constants.NODE_META_DATA).setValue(userDetails){(error,databaseRef) in
//            if let error = error{
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
    
    @IBAction func checkUnchekBtnPressed(_ sender: UIButton) {
        sender.animateView(sender)
    }
}

