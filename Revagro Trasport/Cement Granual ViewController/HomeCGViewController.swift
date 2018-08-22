//
//  HomeCGViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 14/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PKHUD


protocol StartShiftVCBtnTitleDelegate {
    func btnTitle(change:String)
}

class HomeCGViewController: UIViewController , changeBtnImageDelegate, locationDataPassing{
    
    
    
    func btnImage(btnImage: UIImage) {
        self.pointageImageView.image = btnImage
        _ = PointageVC.init(btnOneImage: btnImage)
    }
    
    var delegate: StartShiftVCBtnTitleDelegate?
    
    @IBOutlet weak var pointageBtn: UIButton!
    @IBOutlet weak var badgeBtn: UIButton!
    @IBOutlet weak var changerBtn: UIButton!
    @IBOutlet weak var dechargerBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var pointageImageView: UIImageView!
    @IBOutlet weak var badgeLigneImageView: UIImageView!
    @IBOutlet weak var changerLigneImageView: UIImageView!
    @IBOutlet weak var dechargerImageView: UIImageView!
    @IBOutlet weak var addCommentTextField: UITextField!
    
  
    var btnBackGroundImage:UIImage?
    var startShift: StartShift?
    var startShiftData: StartShiftData?
    var pointagevc: PointageVC?
    var ref: DatabaseReference!
    var loadLocation = String()
    var looseLoaction = String()
    var caliber = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        //btnTitlesOfHomeCGVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //btnTitlesOfHomeCGVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        self.title = "Home"
        submitBtn.layer.cornerRadius = 10
        let revealController = SWRevealViewController()
        revealController.tapGestureRecognizer()
        revealController.panGestureRecognizer()
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
        //pointageImageView.image = #imageLiteral(resourceName: "63")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnTitlesOfHomeCGVC()
    }
    
    // MARK:- BUTTON TITLES
    func btnTitlesOfHomeCGVC(){
        pointageBtn.setTitle(startShift?.btnOne, for: .normal)
        badgeBtn.setTitle(startShift?.btnTwo, for: .normal)
        changerBtn.setTitle(startShift?.btnThree, for: .normal)
        dechargerBtn.setTitle(startShift?.btnFour, for: .normal)
        //print(pointagevc?.btnOneImage)
        //pointageImageView.image = pointagevc?.btnOneImage ?? UIImage.init(named: "63")
    }
    
    
    //MARK:- POINTAGE BUTTON PRESSED
    @IBAction func pointageBtnPressed(_ sender: UIButton) {
        
        if (pointageBtn.title(for: .normal) == "POINTAGE"){
            let vc:PointageViewController = storyboard?.instantiateViewController(withIdentifier: "PointageViewController") as! PointageViewController
            vc.delegate = self
            vc.placeHolder = "Caliber"
            vc.locationDelegate = self
        
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (pointageBtn.title(for: UIControlState.normal) == "ARRIVAGE STOCK"){
            let vc:PointageViewController = storyboard?.instantiateViewController(withIdentifier: "PointageViewController") as!PointageViewController
            vc.placeHolder = "Raw Material"
            vc.delegate = self
            vc.locationDelegate = self
        
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- LOAD AND LOOSE LOCATIONS FROM NEXT VIEWCONTROLLER
    func locations(loadLoaction: String, looseLocation: String, caliber: String) {
        self.loadLocation = loadLoaction
        self.looseLoaction = looseLocation
        self.caliber = caliber
    }
    
    //MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        
        let data:[String: AnyObject] = ["driver_name": startShiftData?.driverName as AnyObject,
                                        "assignment_type": startShiftData?.assignmentType as AnyObject,
                                        "mileage": startShiftData?.mileage as AnyObject,
                                        "date": startShiftData?.date as AnyObject,
                                        "time": startShiftData?.time as AnyObject,
                                        "vehicle_number": startShiftData?.number as AnyObject,
                                        "pause_reason": startShiftData?.reason as AnyObject,
                                        "caliber": self.caliber as AnyObject,
                                        "load_location": self.loadLocation as AnyObject,
                                        "loose_location": self.looseLoaction as AnyObject,
                                        "comment": self.addCommentTextField.text as AnyObject]
        
        ref.child(Constants.NODE_START_SHIFT).child(userid!).childByAutoId().setValue(data) { (error, databaseRef) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            HUD.hide()
        }
        
    }
    
    //MARK:- BADGELIGNE BUTTON PRESSED
    @IBAction func badgeLigneBtnPressed(_ sender: UIButton) {
        self.poptoSpecificVC(viewController: HomeViewController.self)
    }
    
    //MARK:- SUBMIT BUTTON PRESSED
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if self.loadLocation == "" {
            print(self.loadLocation)
            HUD.flash(.label("Please select load and loose location from next screen"), onView: view, delay: 2.0) { (true) in
                
            }
        } else {
            self.saveData()
            Helper.setPREF(Strings.END_SHIFT, key: UserDefaults.PREF_SHIFT_NAME)
            self.poptoSpecificVC(viewController: HomeViewController.self)
        }
    }
    
    //MARK:- POP TO SPECIFIC VIEWCONTROLLER
    func poptoSpecificVC(viewController : Swift.AnyClass){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController.isKind(of: viewController) {
                self.navigationController!.popToViewController(aViewController, animated: true)
                break;
            }
        }
    }
    
}
