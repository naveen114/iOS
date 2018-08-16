//
//  MaintenanceViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import CarbonKit

class MaintenanceViewController: UIViewController,CarbonTabSwipeNavigationDelegate {
    
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllMaintenanceViewController") as! AllMaintenanceViewController
            return controller
        default:
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MaintenanceHistoryViewController") as! MaintenanceHistoryViewController
            return controller
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        let items = ["All Maintenance", "History"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonKitCustomization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carbonKitCustomization(){
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = RevagroColors.NAVIGATIONBAR_BACKGROUND_COLOR
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.blue)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 2, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.setTabBarHeight(64)
        carbonTabSwipeNavigation.setNormalColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 24))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 24))
        //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.LANDSCAP_SCREEN_WIDTH, forSegmentAt: 0)
        //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.LANDSCAP_SCREEN_WIDTH, forSegmentAt: 1)
    }
    
    
    func designUI(){
        
        let revealController = SWRevealViewController()
        revealController.tapGestureRecognizer()
        revealController.panGestureRecognizer()
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    
    }
    
    
    
}
