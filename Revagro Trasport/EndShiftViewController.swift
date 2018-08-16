//
//  EndShiftViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 18/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

class EndShiftViewController: UIViewController {
    
    class func instantiateVC() -> EndShiftViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EndShiftViewController") as! EndShiftViewController
        
        return controller
    }
    
    @IBOutlet weak var mileageTextField: UITextField!
    
    @IBOutlet weak var endShiftBtn: UIButton!
    
    
    @IBOutlet weak var hideBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func showEndShiftVC() {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            //viewWillAppear(true)
            didMove(toParentViewController: topViewController)
        }
    }
    
    public func showVC() {
        showEndShiftVC()
    }
    func designUI(){
        endShiftBtn.layer.cornerRadius = 10
        endShiftBtn.backgroundColor = UIColor(red: 21/255, green: 92/255, blue: 161/255, alpha: 1)
    }
    
    @IBAction func hideShiftBtnPressed(_ sender: UIButton) {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    @IBAction func endShiftBtnPressed(_ sender: UIButton) {
        
    }
    
}
