//
//  Helper.swift
//  Doelse
//
//  Created by Apple on 16/12/17.
//  Copyright © 2017 ATPL. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    //MARK:- set and get preferences for NSString
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    // NSUserDefaults methods which have been used in entire app.
    
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getUserPREF(_ key: String) -> Data? {
        return Foundation.UserDefaults.standard.value(forKey: key as String) as? Data
    }
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for string
     abstract To delete the preference value for the key that has been passed
     */
    class func  delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Integer
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getIntPREF(_ key: String) -> Int? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Int
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setIntPREF(_ sValue: Int, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for integer
     abstract To delete the preference value for the key that has been passed
     */
    
    class func  delIntPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Double
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getDoublePREF(_ key: String) -> Double? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Double
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setDoublePREF(_ sValue: Double, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Array
    /*!
     method getPreferenceValueForKey for array
     abstract To get the preference value for the key that has been passed
     */
    class func getArrPREF(_ key: String) -> [Int]? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? [Int]
    }
    /*!
     method setPreferenceValueForKey for array
     abstract To set the preference value for the key that has been passed
     */
    class func setArrPREF(_ sValue: [Int], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF
     abstract To delete the preference value for the key that has been passed
     */
    class func  delArrPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Dictionary
    /*!
     method getPreferenceValueForKey for dictionary
     abstract To get the preference value for the key that has been passed
     */
    class func getDicPREF(_ key: String)-> NSDictionary {
        let data = Foundation.UserDefaults.standard.object(forKey: key as String) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: String]
        return object as NSDictionary
    }
    /*!
     method setPreferenceValueForKey for dictionary
     abstract To set the preference value for the key that has been passed
     */
    class func setDicPREF(_ sValue: NSDictionary, key: String) {
        Foundation.UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: sValue), forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Boolean
    /*!
     method getPreferenceValueForKey for boolean
     abstract To get the preference value for the key that has been passed
     */
    class func getBoolPREF(_ key: String) -> Bool {
        return Foundation.UserDefaults.standard.bool(forKey: key as String)
    }
    /*!
     method setBoolPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setBoolPREF(_ sValue: Bool , key: String){
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for boolean
     abstract To delete the preference value for the key that has been passed
     */
    class func  delBoolPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    
//    class func showOkCancelAlert(onVC viewController: UIViewController, title: String, message: String, btnOk: String, btnCancel: String, image: UIImage, onOk:@escaping ()->()) {
//        DispatchQueue.main.async {
//            
//        }
//    }
//    
//    class func showOkAlert(onVC viewController: UIViewController, title: String, message: String, btnOk: String, image: UIImage) {
//        DispatchQueue.main.async {
//            
//        }
//    }
    
    class func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
        DispatchQueue.main.async {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                print("Take Photo")
                
                onTakePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                print("Choose from library")
                
                onChooseFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
            if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                var rect = viewController.view.frame;
                
                rect.origin.x = viewController.view.frame.size.width / 20;
                rect.origin.y = viewController.view.frame.size.height / 20;
                
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = rect
            }
            
            actionSheetControllerIOS8.view.tintColor = UIColor.black
            viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
}

