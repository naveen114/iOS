//
//  File.swift
//  Revagro Trasport
//
//  Created by ATPL on 12/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func animateView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
    }
}

// MARK: - UICOLOR EXTENSION
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
