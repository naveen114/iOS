//
//  AppUtils.swift
//  Revagro Trasport
//
//  Created by ATPL on 04/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import Foundation
import UIKit

class AppUtils {
    class func showViewController(withIdentifier:String, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: withIdentifier)
        viewController.present(controller, animated: true, completion: nil)
    }
    
    class func showAlert(title:String,message : String,viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertandPopViewController(title:String,message : String,viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert:UIAlertAction) in
            viewController.navigationController?.popViewController(animated: true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormtter = DateFormatter()
        newDateFormtter.dateFormat = "dd-MM-yyyy"
        return newDateFormtter.string(from: date ?? Date())
    }
    
    class func convertDay(_ dayString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dayString)
        
        let newDateFormtter = DateFormatter()
        newDateFormtter.dateFormat = "EEEE"
        return newDateFormtter.string(from: date ?? Date())
    }
    
    class func convertDateFormat(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormtter = DateFormatter()
        newDateFormtter.dateFormat = "MMM d, yyyy"
        return newDateFormtter.string(from: date ?? Date())
    }
}
