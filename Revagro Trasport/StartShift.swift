//
//  StartShift.swift
//  Revagro Trasport
//
//  Created by ATPL on 16/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

class StartShift: NSObject {
    var btnOne:String = ""
    var btnTwo:String = ""
    var btnThree:String = ""
    var btnFour:String = ""
    
    init(btnOne: String, btnTwo: String, btnThree: String, btnFour: String) {
        self.btnOne = btnOne
        self.btnTwo = btnTwo
        self.btnThree = btnThree
        self.btnFour = btnFour
    }
}


class StartShiftData: NSObject {
    var driverName:String = ""
    var assignmentType:String = ""
    var mileage:Int = 0
    var date:String = ""
    var time:String = ""
    var number:String = ""
    var reason:String = ""
    
    init(driverName: String, assignmentType: String, mileage: Int, date: String, time: String, number: String, reason: String) {
        self.driverName = driverName
        self.assignmentType = assignmentType
        self.mileage = mileage
        self.date = date
        self.time = time
        self.number = number
        self.reason = reason
    }
}


class PointageVC: NSObject{
    var btnOneImage:UIImage?
    init (btnOneImage:UIImage){
        self.btnOneImage = btnOneImage
        
    }
}

class HomeVC: NSObject{
    var btnTitle:String?
    init(btnTitle:String){
        self.btnTitle = btnTitle
    }
    
}

