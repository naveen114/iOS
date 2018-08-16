//
//  HomeCGViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 14/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit


protocol StartShiftVCBtnTitleDelegate {
    func btnTitle(change:String)
}

class HomeCGViewController: UIViewController , changeBtnImageDelegate{
    
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
   
    var pointagevc: PointageVC?
    
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
        
            self.navigationController?.pushViewController(vc, animated: true)
        }else if (pointageBtn.title(for: UIControlState.normal) == "ARRIVAGE STOCK"){
            let vc:PointageViewController = storyboard?.instantiateViewController(withIdentifier: "PointageViewController") as!PointageViewController
            vc.placeHolder = "Raw Material"
            vc.delegate = self
        
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK:- BADGELIGNE BUTTON PRESSED
    @IBAction func badgeLigneBtnPressed(_ sender: UIButton) {
        self.poptoSpecificVC(viewController: HomeViewController.self)
    }
    
    //MARK:- SUBMIT BUTTON PRESSED
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        Helper.setPREF(Strings.END_SHIFT, key: UserDefaults.PREF_SHIFT_NAME)
        self.poptoSpecificVC(viewController: HomeViewController.self)
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
