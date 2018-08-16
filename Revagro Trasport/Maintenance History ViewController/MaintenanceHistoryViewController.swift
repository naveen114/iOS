//
//  MaintenanceHistoryViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 06/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PKHUD


class MaintenanceDataCell:UITableViewCell{
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var carroseriesImage: UIImageView!
    @IBOutlet weak var maintenanceDataCellView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
}
class MaintenanceHeaderCell:UITableViewCell{
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
}

class MaintenanceHistoryViewController: UIViewController {
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var lastMaintenanceDateLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var calendarImage: UIImageView!
    
    var sectionsName = ["FUEL", "LEVEL OF LIQUID", "CARROSERIES", "PNEUS", "FEUX", "LAMES", "VERRINS", "TUYAUX HYDRAULICS", "GRAISSAGE", "CARDANS", "CLEANING THE TRUCK", "CABIN"]
    var sectionImages:[UIImage] = [#imageLiteral(resourceName: "fuel"),#imageLiteral(resourceName: "liquidLevel"),#imageLiteral(resourceName: "Carroseries"),#imageLiteral(resourceName: "Pneus"),#imageLiteral(resourceName: "Feux"),#imageLiteral(resourceName: "Lames"),#imageLiteral(resourceName: "Verrins"),#imageLiteral(resourceName: "Tuyaux hydraulics"),#imageLiteral(resourceName: "Graissage"),#imageLiteral(resourceName: "Cardans"),#imageLiteral(resourceName: "Cleaning the truck"),#imageLiteral(resourceName: "Cabin")]
    
    //var arrFuelData:[String] = ["Counter storage tank for refueling : 100", "Fuel quantity refueled : 90", "Counter storage tank after refueling : 90"]
    //var arrLevelOfLiquid:[String] = ["Engine oil : 20", "Hydraulic oil : 10", "Liquid cooling : 25", "Directional oil : 5", "Washing Machine : 15" ]
    //var arrCarroseries:[String] = ["Comment :" ,"A long comment by user or driver about truck etc etc"]
    //var arrPneus:[String] = ["1 ess. AV :" , "Gauche : 14" , "Droit : 14" , "2 ess. AV :" , "Gauche : 14" , "Droit : 15" , "1 ess. AR :" , "Gauche : 15" , "Gauche Droit : 12" , "Droit Gauche : 14" , "Droit Droit : 15"]
    //var arrFeus:[String] = ["AV Gauche : 28", "AV Droit : 22", "ARR Gauche : 12" , "ARR Droit : 14"]
    //var arrLames:[String] = ["AV gauche : OK", "AV droit : OK", "ARR gauche : OK" , "ARR droit : Not OK"]
    //var arrVerins:[String] = ["Central Bene : OK", "Porte Gauche : Not OK" , "Porte Droit : OK"]
    //var arrTuyaucHydraulics:[String] = ["Tuyaux Hydraulics : OK"]
    //var arrGraissage:[String] = ["Crochet bene : OK" ,"Bras securite gauche : Not OK" ,"Bras securite droit : Not OK", "Ligne 1 : 23", "Ligne 2 : 23", "Compas : 14"]
    //var arrCardans:[String] = ["Cardan 1 : OK", "Cardan 2 : Not OK", "Cardan 3 : Not OK"]
    //var arrCleaningTruck:[String] = ["CCB : OK", "MAN Barry : Not OK"]
    //var arrCabin:[String] = ["Essuies glace : OK" ,"Temoins securites : OK" ,"Proprete : Not OK " ,"Nettoyage filter cabin : Not Ok" ,"Nettoyage filter moteur : OK"]
    
    var arrCabin = [String]()
    var arrFuelData = [String]()
    var arrLevelOfLiquid = [String]()
    var arrCarroseries = [String]()
    var arrPneus = [String]()
    var arrFeux = [String]()
    var arrLames = [String]()
    var arrVerrins = [String]()
    var arrTuyaucHydraulics = [String]()
    var arrGraissage = [String]()
    var arrCardans = [String]()
    var arrCleaningTruck = [String]()
    var image = UIImage()
    
    var ref:DatabaseReference!
    var storageRef:StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        fetchFuelData()
        fetchFeuxData()
        fetchCabinData()
        fetchLamesData()
        fetchPneusData()
        fetchCardansData()
        fetchCardansData()
        fetchVerrinsData()
        fetchGraissageData()
        fetchHydraulicData()
        fetchCarroseriesData()
        fetchLiquidLevelData()
    }
    
    //MARK:- FUNCTION HANDLE TAB GESTURE
    @objc fileprivate func handleTap(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.innerView.isHidden = false
        })
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        self.innerView.isHidden = true
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.calendarImage.isUserInteractionEnabled = true
        self.calendarImage.addGestureRecognizer(tabGestureRecognizer)
        self.innerView.layer.cornerRadius = 10
        self.calendarView.layer.cornerRadius = 10
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.lastMaintenanceDateLbl.text = dateFormatter.string(from: date)
    }
    
    //MARK:- FETCH FUEL DATA FROM FIREBASE
    func fetchFuelData(){
        HUD.show(.progress)
        self.arrFuelData.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text!).child(Constants.NODE_FUEL).observe(.value) { (snapshot) in
            print(snapshot)
            //var arrFuelData:[String] = ["Counter storage tank for refueling : 100", "Fuel quantity refueled : 90", "Counter storage tank after refueling : 90"]
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let fuelRefueled = dictionary["fuel_quantity_refueled"] as? String{
                    print(fuelRefueled)
                    self.arrFuelData.append("Fuel quantity refueled : \(fuelRefueled)")
                }
                if let afterRefueling = dictionary["tank_after_refueling"] as? String{
                    print(afterRefueling)
                    self.arrFuelData.append("Counter storage tank after refueling : \(afterRefueling)")
                }
                if let forRefueling = dictionary["tank_for_refueling"] as? String{
                    print(forRefueling)
                    self.arrFuelData.append("Counter storage tank for refueling : \(forRefueling)")
                }
            }
            self.tableVieww.reloadData()
            HUD.hide()
        }
    }
    
    //MARK:- FETCH LIQUID LEVEL DATA FROM FIREBASE
    func fetchLiquidLevelData(){
        HUD.show(.progress)
        self.arrLevelOfLiquid.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text!).child(Constants.NODE_LIQUID_LEVEL).observe(.value) { (snapshot) in
            print(snapshot)
            //var arrLevelOfLiquid:[String] = ["Engine oil : 20", "Hydraulic oil : 10", "Liquid cooling : 25", "Directional oil : 5", "Washing Machine : 15" ]
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let directionalOil = dictionary["directional_oil"] as? String{
                    print(directionalOil)
                    self.arrLevelOfLiquid.append("Directional oil : \(directionalOil)")
                }
                if let engienOil = dictionary["engine_oil"] as? String{
                    print(engienOil)
                    self.arrLevelOfLiquid.append("Engine oil : \(engienOil)")
                }
                if let hydraulicOil = dictionary["hydraulic_oil"] as? String{
                    print(hydraulicOil)
                    self.arrLevelOfLiquid.append("Hydraulic oil : \(hydraulicOil)")
                }
                if let liquidCooling = dictionary["liquid_cooling"] as? String{
                    print(liquidCooling)
                    self.arrLevelOfLiquid.append("Liquid cooling : \(liquidCooling)")
                }
                if let washingMachine = dictionary["washing_machine"] as? String{
                    print(washingMachine)
                    self.arrLevelOfLiquid.append("Washing Machine : \(washingMachine)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
        
    }
    
    //MARK:- FETCH CARROSERIES DATA FROM FIREBASE
    func fetchCarroseriesData(){
        HUD.show(.progress)
        self.arrCarroseries.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text!).child(Constants.NODE_CARROSERIES).observe(.value) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let comment = dictionary["comment"] as? String{
                    print(comment)
                    self.arrCarroseries.append("Comment : \(comment)")
                }
                if let url = dictionary["upload_photo"] as? String  {
                    print(url)
                    let photorUrl = URL(string: url)
                    let session = URLSession(configuration: .default)
                    let downloadTask = session.dataTask(with: photorUrl!) {(data, response, error) in
                        
                        if let error = error{
                            print(error.localizedDescription)
                        } else {
                            if let res = response as? HTTPURLResponse{
                                print(res.statusCode)
                            }
                            if let imageData = data {
                                let imagee = UIImage(data: imageData)
                                print(imagee?.size)
                                self.image = imagee ?? UIImage()
                                
                            }
                        }
                        
                    }
                    downloadTask.resume()
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    
    //MARK:- FETCH PNEUS DATA FROM FIREBASE
    func fetchPneusData(){
        HUD.show(.progress)
        self.arrPneus.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
       //var arrPneus:[String] = ["1 ess. AV :" , "Gauche : 14" , "Droit : 14" , "2 ess. AV :" , "Gauche : 14" , "Droit : 15" , "1 ess. AR :" , "Gauche : 15" , "Gauche Droit : 12" , "Droit Gauche : 14" , "Droit Droit : 15"]
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_PNEUS).observe(.value) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let lineOne = dictionary["1_ess_av_gauche"] as? String{
                    self.arrPneus.append("1 ess. AV :")
                    self.arrPneus.append("Gauche : \(lineOne)")
                }
                if let lineTwo = dictionary["1_ess_av_droit"] as? String{
                    self.arrPneus.append("Droit : \(lineTwo)")
                }
                if let lineThree = dictionary["2_ess_av_gauche"] as? String{
                    self.arrPneus.append("Gauche : \(lineThree)")
                }
                if let lineFour = dictionary["2_ess_av_droit"] as? Bool{
                    self.arrPneus.append("2 ess. AV :")
                    self.arrPneus.append("Droit : \(lineFour)")
                }
                if let linefive = dictionary["1_ess_ar_gauche"] as? String{
                    self.arrPneus.append("Gauche : \(linefive)")
                }
                if let lineSix = dictionary["1_ess_ar_droit"] as? String{
                    self.arrPneus.append("Gauche Droit : \(lineSix)")
                }
                if let lineSeven = dictionary["2_ess_ar_droit_gauche"] as? String{
                    self.arrPneus.append("1 ess. AR :")
                    self.arrPneus.append("Droit Gauche : \(lineSeven)")
                }
                if let lineEight = dictionary["2_ess_ar_droit_droit"] as? String{
                    self.arrPneus.append("Droit Droit : \(lineEight)")
                    
                }
                if let url = dictionary["photo_url"] as? String{
                 print(url)
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    //MARK:- FETCH FEUX DATA FROM FIREBASE
    func fetchFeuxData(){
        HUD.show(.progress)
        self.arrFeux.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
    ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_FEUX).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let lineOne = dictionary["av_gauche"] as? String{
                    self.arrFeux.append("AV Gauche : \(lineOne)")
                    
                }
                if let lineTwo = dictionary["ar_droit"] as? String{
                    self.arrFeux.append("AV Droit : \(lineTwo)")
                }
                if let lineThree = dictionary["arr_gauche"] as? String{
                    self.arrFeux.append("ARR Gauche : \(lineThree)")
                }
                if let lineFour = dictionary["arr_droit"] as? String{
                    self.arrFeux.append(" ARR Droit : \(lineFour)")
                }
            }
        HUD.hide()
        self.tableVieww.reloadData()
        }
    }
    //MARK:- FETCH LAMES DATA FROM FIREBASE
    func fetchLamesData(){
        HUD.show(.progress)
        self.arrLames.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_LAMES).observe(.value) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if let lineOne = dictionary["av_gauche"] as? Bool{
                    self.arrLames.append("AV gauche : \(lineOne)")
                }
                if let lineTwo = dictionary["av_droit"] as? Bool{
                    self.arrLames.append("AV droit : \(lineTwo)")
                }
                if let lineThree = dictionary["arr_gauche"] as? Bool{
                    self.arrLames.append("ARR gauche : \(lineThree)")
                }
                if let lineFour = dictionary["arr_droit"] as? Bool{
                    self.arrLames.append("ARR droit : \(lineFour)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    //MARK:- FETCH VERRINS DATA FROM FIREBASE
    func fetchVerrinsData(){
        HUD.show(.progress)
        self.arrVerrins.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_VERRINS).observe(.value) { (snapshot) in
            print(snapshot)
            if let dict = snapshot.value as? [String: AnyObject]{
                if let one = dict["central_benne"] as? Bool{
                self.arrVerrins.append("Central Bene : \(one)")
                }
                if let two = dict["port_gauche"] as? Bool{
                   self.arrVerrins.append("Porte Gauche : \(two)")
                }
                if let three = dict["port_droit"] as? Bool{
                    self.arrVerrins.append("Porte Droit : \(three)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    //MARK:- FETCH HYDRAULIC DATA FROM FIREBASE
    func fetchHydraulicData(){
        HUD.show(.progress)
        self.arrTuyaucHydraulics.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_HYDRAULICS_TUYAUX).observe(.value) { (snapshot) in
            print(snapshot)
            if let dict = snapshot.value as? [String: AnyObject]{
                if let hydraulic = dict["hydraulics"] as? Bool{
                    self.arrTuyaucHydraulics.append("Tuyaux Hydraulics : \(hydraulic)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
        
    }
    //MARK:- FETCH GRAISSAGE DATA FROM FIREBASE
    func fetchGraissageData(){
        HUD.show(.progress)
        self.arrGraissage.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
       
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_HYDRAULICS_TUYAUX).observe(.value) { (snap) in
            print(snap)
            if let dict = snap.value as? [String: AnyObject]{
                if let one = dict["crochet_bene"] as? Bool{
                    self.arrGraissage.append("Crochet bene : \(one)")
                }
                if let two = dict["bras_securite_gauche"] as? Bool{
                   self.arrGraissage.append("Bras securite gauche : \(two)")
                }
                if let three = dict["bras_securite_droit"] as? Bool{
                    self.arrGraissage.append("Bras securite droit : \(three)")
                }
                if let ligne1 = dict["ligne 1"] as? String{
                   self.arrGraissage.append("Ligne 1 : \(ligne1)")
                }
                if let ligne2 = dict["ligne 2"] as? String{
                 self.arrGraissage.append("Ligne 2 : \(ligne2)")
                }
                if let compas = dict["compas"] as? String{
                    self.arrGraissage.append("Compas : \(compas)")
                }
            }
            HUD.hide()
            
            self.tableVieww.reloadData()
        }
        
    }
    //MARK:- FETCH CARDAN DATA FROM FIREBASE
    func fetchCardansData(){
        HUD.show(.progress)
        self.arrCardans.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
//        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_CARDAN).observe(.value) { (snapshot) in
//            print(snapshot)
//            if let dict = snapshot.value as? [String: AnyObject]{
//                if let cardan1 = dict["cardan1"] as? Bool{
//                    self.arrCardans.append("Cardan 1 : \(cardan1)")
//                }
//                if let cardan2 = dict["cardan2"] as? Bool{
//                    self.arrCardans.append("Cardan 2 : \(cardan2)")
//                }
//                if let cardan3 = dict["cardan3"] as? Bool{
//                    self.arrCardans.append("Cardan 3 : \(cardan3)")
//                }
//            }
//            HUD.hide()
//            self.tableVieww.reloadData()
//        }
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_CARDAN).observeSingleEvent(of: .value) { (snap) in
            print(snap)
            
            if let dict = snap.value as? [String: AnyObject]{
                if let cardan1 = dict["cardan1"] as? Bool{
                    self.arrCardans.append("Cardan 1 : \(cardan1)")
                }
                if let cardan2 = dict["cardan2"] as? Bool{
                    self.arrCardans.append("Cardan 2 : \(cardan2)")
                }
                if let cardan3 = dict["cardan3"] as? Bool{
                    self.arrCardans.append("Cardan 3 : \(cardan3)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
        
    }
    //MARK:- FETCH TRUCK CLEANING DATA FROM FIREBASE
    func fetchTruckCleaningData(){
        HUD.show(.progress)
        self.arrCleaningTruck.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_CLEANING_TRUCK).observe(.value) { (snap) in
            print(snap)
            if let dict = snap.value as? [String: AnyObject] {
                if let ccb = dict["ccb"] as? Bool{
                    self.arrCleaningTruck.append("CCB : \(ccb)")
                }
                if let manBerry = dict["man_barry"] as? Bool{
                    self.arrCleaningTruck.append("MAN Barry : \(manBerry)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    //MARK:- FETCH CABIN DATA FROM FIREBASE
    func fetchCabinData(){
        HUD.show(.progress)
        self.arrCabin.removeAll()
        ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        
        ref.child(Constants.NODE_MAINTENANCE).child(userId!).child(Constants.NODE_MAINTENANCE_DATE).child(self.lastMaintenanceDateLbl.text ?? "").child(Constants.NODE_CABIN).observe(.value) { (snap) in
            print(snap)
            if let dict = snap.value as? [String: AnyObject]{
                if let one = dict["essuies_glace"] as? Bool {
                    self.arrCabin.append("Essuies glace : \(one)")
                }
                if let two = dict["temoins_securites"] as? Bool {
                    self.arrCabin.append("Temoins securites : \(two)")
                }
                if let three = dict["proprete"] as? Bool {
                    self.arrCabin.append("Proprete : \(three)")
                }
                if let four = dict["nettoyage_filter_cabin"] as? Bool {
                    self.arrCabin.append("Nettoyage filter cabin : \(four)")
                }
                if let five = dict["nettoyage_filter_moteur"] as? Bool {
                    self.arrCabin.append("Nettoyage filter moteur : \(five)")
                }
            }
            HUD.hide()
            self.tableVieww.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- CANCEL BUTTON PRESSED
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.innerView.isHidden = true
        })
    }
    
    //MARK:- DONE BUTTON PRESSED
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.innerView.isHidden = true
        })
    }
    
    
}

//MARK:- EXTENSION OF TABLE VIEW
extension MaintenanceHistoryViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrFuelData.count
        case 1:
            return arrLevelOfLiquid.count
        case 2:
            return arrCarroseries.count
        case 3:
            return arrPneus.count
        case 4:
            return arrFeux.count
        case 5:
            return arrLames.count
        case 6:
            return arrVerrins.count
        case 7:
            return arrTuyaucHydraulics.count
        case 8:
            return arrGraissage.count
        case 9:
            return arrCardans.count
        case 10:
            return arrCleaningTruck.count
            
        default:
            return arrCabin.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceDataCell", for: indexPath) as! MaintenanceDataCell
        
        
        if  (indexPath.section == 0) {
            cell.fieldNameLbl.text = arrFuelData[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 1) {
            cell.fieldNameLbl.text = arrLevelOfLiquid[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 2){
            cell.fieldNameLbl.text = arrCarroseries[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            if indexPath.row == 0 {
                cell.carroseriesImage.image = nil
                cell.imageHeight.constant = 0
            } else {
                cell.carroseriesImage.image = self.image
                cell.imageHeight.constant = 200
            }
        } else if (indexPath.section == 3) {
            cell.fieldNameLbl.text = arrPneus[indexPath.row]
            cell.imageHeight.constant = 0
            cell.carroseriesImage.image = nil
            cell.imageHeight.priority = UILayoutPriority.init(250)
            if cell.fieldNameLbl.text == "1 ess. AV :"{
                cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_14
            } else if cell.fieldNameLbl.text == "2 ess. AV :" {
                cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_14
            } else if cell.fieldNameLbl.text == "1 ess. AR :"{
                cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_14
            } else {
                cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            }
        }
        else if (indexPath.section == 4) {
            cell.fieldNameLbl.text = arrFeux[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 5) {
            cell.fieldNameLbl.text = arrLames[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 6) {
            cell.fieldNameLbl.text = arrVerrins[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 7) {
            cell.fieldNameLbl.text = arrTuyaucHydraulics[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 8) {
            cell.fieldNameLbl.text = arrGraissage[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 9) {
            cell.fieldNameLbl.text = arrCardans[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 10) {
            cell.fieldNameLbl.text = arrCleaningTruck[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        } else if (indexPath.section == 11) {
            cell.fieldNameLbl.text = arrCabin[indexPath.row]
            cell.fieldNameLbl.font = RevagroFonts.FONT_ARIAL_REGULAR_12
            cell.carroseriesImage.image = nil
            cell.imageHeight.constant = 0
            cell.imageHeight.priority = UILayoutPriority.init(250)
        }
        //self.tableVieww.reloadData()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceHeaderCell") as! MaintenanceHeaderCell
        switch section {
        case 0:
            cell.headerName.text = "FUEL"
            cell.headerImage.image = #imageLiteral(resourceName: "fuel")
            
        case 1:
            cell.headerName.text = "LEVEL OF LIQUID"
            cell.headerImage.image = #imageLiteral(resourceName: "liquidLevel")
            
        case 2:
            cell.headerName.text = "CARROSERIES"
            cell.headerImage.image = #imageLiteral(resourceName: "Carroseries")
            
        case 3:
            cell.headerName.text = "PNEUS"
            cell.headerImage.image = #imageLiteral(resourceName: "Pneus")
            
        case 4:
            cell.headerName.text = "FEUX"
            cell.headerImage.image = #imageLiteral(resourceName: "Feux")
            
        case 5:
            cell.headerName.text = "LAMES"
            cell.headerImage.image = #imageLiteral(resourceName: "Lames")
            
        case 6:
            cell.headerName.text = "VERRINS"
            cell.headerImage.image = #imageLiteral(resourceName: "Verrins")
            
        case 7:
            cell.headerName.text = "TUYAUX HYDRAULICS"
            cell.headerImage.image = #imageLiteral(resourceName: "Tuyaux hydraulics")
            
        case 8:
            cell.headerName.text = "GRAISSAGE"
            cell.headerImage.image = #imageLiteral(resourceName: "Graissage")
            
        case 9:
            cell.headerName.text = "CARDANS"
            cell.headerImage.image = #imageLiteral(resourceName: "Cardans")
            
        case 10:
            cell.headerName.text = "CLEANING THE TRUCK"
            cell.headerImage.image = #imageLiteral(resourceName: "Cleaning the truck")
            
        default:
            cell.headerName.text = "CABIN"
            cell.headerImage.image = #imageLiteral(resourceName: "Cabin")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

//MARK:- EXTENSION OF CALENDAR
extension MaintenanceHistoryViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("select")
        let selectedDate = self.calendarView.selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: selectedDate ?? Date())
        print(date)
        self.lastMaintenanceDateLbl.text = date
        self.fetchFuelData()
        self.fetchFeuxData()
        self.fetchCabinData()
        self.fetchLamesData()
        self.fetchPneusData()
        self.fetchCardansData()
        self.fetchCardansData()
        self.fetchVerrinsData()
        self.fetchGraissageData()
        self.fetchHydraulicData()
        self.fetchCarroseriesData()
        self.fetchLiquidLevelData()
    }
}
