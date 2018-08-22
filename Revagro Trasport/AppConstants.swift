//
//  AppConstants.swift
//  Doelse
//
//  Created by Apple on 18/12/17.
//  Copyright © 2017 ATPL. All rights reserved.
//

import UIKit

struct CurrentDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let iPhone4S = isiPhone && UIScreen.main.bounds.size.height == 480
    static let iPhone5  = isiPhone && UIScreen.main.bounds.size.height == 568.0
    static let iPhone6  = isiPhone && UIScreen.main.bounds.size.height == 667.0
    static let iPhone6P = isiPhone && UIScreen.main.bounds.size.height == 736.0
    static let iPhoneX  = isiPhone && UIScreen.main.bounds.size.height == 812.0
    
    static let isiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let iPadMini = isiPad && UIScreen.main.bounds.size.height <= 1024
}

struct AppConstants {
    static let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    static let PORTRAIT_SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let PORTRAIT_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let CURRENT_IOS_VERSION = UIDevice.current.systemVersion
    static let LANDSCAP_SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let LANDSCAP_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

// App custom cells name
struct CellIds {
    static let FindFreelancerCell           = "FindFreelancerCell"
    static let FindJobsCell                 = "FindJobsCell"
    static let ClientProfileTableViewCell   = "ClientProfileTableViewCell"
    static let PaymentCollectionViewCell    = "PaymentCollectionViewCell"
}


// Color Constants
struct RevagroColors {
    static let NAVIGATIONBAR_BACKGROUND_COLOR = UIColor.init(red: 223/255, green: 99/255, blue: 8/255, alpha: 1)
    static let NAVIGATIONBAR_TITLE_COLOR = UIColor.white
    static let SAVE_BUTTON_BACGROUND_COLOR = UIColor(red: 56/255.0, green: 171/255.0, blue: 57/255.0, alpha: 1)
    static let LABEL_BACKGROUND_COLOR = UIColor.init(hex: "0472b1")
}

// Font Constants
struct RevagroFonts{
    static let FONT_ARIAL_REGULAR_12  = UIFont.init(name: "arial", size: 25)
    static let FONT_ARIAL_REGULAR_14  = UIFont.init(name: "arial", size: 35)
    static let FONT_ROBOTO_REGULAR_16  = UIFont.init(name: "Roboto-Regular", size: 16)
    static let FONT_ROBOTO_REGULAR_20  = UIFont.init(name: "Roboto-Regular", size: 20)
    static let FONT_ROBOTO_MEDIUM_16 = UIFont(name: "Roboto-Medium", size: 16)
    static let FONT_ROBOTO_MEDIUM_17 = UIFont(name: "Roboto-Medium", size: 17)
    static let FONT_ROBOTO_MEDIUM_18 = UIFont(name: "Roboto-Medium", size: 18)
    static let FONT_ROBOTO_MEDIUM_22 = UIFont(name: "Roboto-Medium", size: 22)
}

struct Strings {
    static let END_SHIFT = "END SHIFT"
    static let START_SHIFT = "START SHIFT"
}

struct Alert {
    static let ERROR = "Error"
    static let SUCCESS = "Success"
    static let ALERT = "Alert"
    static let CONFIRMATION = "Confirmation"
    static let ALERT_SOMETHING_WENT_WRONG = "Whoops, something went wrong. Please refresh and try again."
}


// google constants


