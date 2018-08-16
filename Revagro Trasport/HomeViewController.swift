//
//  HomeViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 01/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import SwiftyJSON
import Firebase

class HomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var shiftBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var googleMapsView: UIView!
    
    var locationManager: CLLocationManager?
    var latitude = 30.752800
    var longitude = 76.804504
    var mode = "driving"
    var googleApiKey = "AIzaSyB1g2zjTP66BLGD5aVjk2K4hfP9xU3Uq0M"
    var jsonResponse = [String:Any]()
    var mapView = GMSMapView()
    var ref: DatabaseReference!
    
    class func instantiateVC() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designUI()
        let shiftStopedImage = UIImage(named: "15")
        let commentImage = UIImage(named: "14")
        let shiftStopedButton = UIBarButtonItem(image: shiftStopedImage, style: .plain, target: self, action: #selector(commentBtnPressed))
        let commentButton = UIBarButtonItem(image: commentImage, style: .plain, target: self, action: #selector(shiftStoppedBtnPressed))
        navigationItem.rightBarButtonItems = [shiftStopedButton, commentButton]
        self.navigationItem.title = "Start Shift"
        detectLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapdisplay()
    }
    
    // MARK: CHECK LOCATION SERVICES
    func detectLocation() {
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                                      message: "Location services are not allowed for Tryfun. To enable location go to Settings, select Tryfun and enable the location.")
            case .notDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager {
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                /* Restrictions have been applied, we have no access
                 to location services */
                displayAlertWithTitle("Restricted",
                                      message: "Location services are not allowed for this app")
            }
        } else {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            print("Location services are not enabled")
        }
    }
    
    func createLocationManager(startImmediately: Bool) {
        locationManager = CLLocationManager()
        if let manager = locationManager {
            print("Successfully created the location manager")
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            if startImmediately {
                manager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error = \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The authorization status of location services is changed to: ", terminator: "")
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("Authorized")
        case .authorizedWhenInUse:
            print("Authorized when in use")
            createPolyline()
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        }
    }
    
    func displayAlertWithTitle(_ title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",  style: .default, handler: nil))
        controller.addAction(UIAlertAction(title: "Settings",  style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                } else {
                    UIApplication.shared.canOpenURL(settingsUrl)
                }
            }
        }))
        controller.view.tintColor = UIColor.black
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - SETUP MAP
    func mapdisplay() {
        if locationManager != nil {
            self.mapView.isMyLocationEnabled = true
            let myLocationCoordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            let camera = GMSCameraPosition.camera(withTarget: myLocationCoordinate, zoom: 12.0)
            self.mapView.delegate = self
            self.mapView = GMSMapView.map(withFrame: self.googleMapsView.frame, camera: camera)
            self.mapView.camera = camera
            self.mapView.settings.compassButton = true
            self.mapView.settings.myLocationButton = true
        }
        
        let startPoint = CLLocationCoordinate2D.init(latitude: locationManager?.location?.coordinate.latitude ?? 0.0, longitude: locationManager?.location?.coordinate.longitude ?? 0.0)
        let startMarker = GMSMarker.init(position: startPoint)
        startMarker.map = self.mapView
        
        let endPoint = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let endMarker = GMSMarker(position: endPoint)
        endMarker.map = self.mapView
        self.googleMapsView.addSubview(self.mapView)
        self.googleMapsView.bringSubview(toFront: self.statusView)
        self.googleMapsView.bringSubview(toFront: self.shiftBtn)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.createPolyline()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        //shiftBtn.setTitle(Helper.getPREF(UserDefaults.PREF_SHIFT_NAME) ?? "Start Shift", for: UIControlState())
    }
    
    func designUI() {
        shiftBtn.backgroundColor = UIColor(red: 56/255.0, green: 171/255.0, blue: 57/255.0, alpha: 1)
        shiftBtn.tintColor = UIColor.white
        
        let revealController = SWRevealViewController()
        revealController.tapGestureRecognizer()
        revealController.panGestureRecognizer()
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(SWRevealViewController.revealToggle(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func shiftStoppedBtnPressed() {
        DispatchQueue.main.async {
            _ = StopShiftViewController.instantiateVC().showVC()
        }
    }
    
    @objc func commentBtnPressed() {
        DispatchQueue.main.async {
            _ = CommentViewController.instantiateVC().showVC()
        }
    }
    
    @IBAction func shiftBtnPressed(_ sender: UIButton) {
        if shiftBtn.title(for: .normal) == "Start Shift" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeeViewController") as! HomeeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if shiftBtn.title(for: .normal) == "End Shift" {
            DispatchQueue.main.async {
                _ = EndShiftViewController.instantiateVC().showVC()
            }
        }
    }
    
    func createPolyline() {
        let location = locationManager?.location
        let coordinate = location?.coordinate
        let originLatLng = "\(coordinate?.latitude ?? 0.0), \(coordinate?.longitude ?? 0.0)"
        let destinationLatLng = String(32.2643) + "," + String(75.6421)
        
        let parameter:Parameters = ["origin": originLatLng, "destination": destinationLatLng, "mode": mode, "Key": googleApiKey]
        print(parameter)
        let url = "https://maps.googleapis.com/maps/api/directions/json?"
        Alamofire.request(url, method: .get, parameters:parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (responseData) in
            print(responseData)
            
            if (responseData.result.value != nil){
                let swiftyJson = JSON(responseData.result.value!)
                //print(swiftyJson)
                
                if (swiftyJson["status"].stringValue == "OK"){
                    if let response = swiftyJson["routes"].arrayObject as? [[String:Any]] {
                        //print(response)
                        for i in 0..<response.count{
                            let dictionary = response[i]
                            if let legs = dictionary["legs"] as? [[String:Any]]{
                                for j in 0..<legs.count{
                                    let legsDictionary = legs[j]
                                    if let distance = legsDictionary["distance"] as? NSDictionary{
                                        if let totalDistance = distance["text"] as? String{
                                            if let duration = legsDictionary["duration"] as? NSDictionary{
                                                if let totalDuration = duration["text"] as? String{
                                                    self.remainingTimeLbl.text = "\(totalDistance) \(totalDuration)"
                                                    //self.addressLabel.text = totalDistance
                                                }
                                            }
                                        }
                                    }
                                    
                                    //
                                    if let endAddress = legsDictionary["end_address"] as? String{
                                        self.addressLabel.text = endAddress
                                    }
                                }
                            }
                            //
                            if let polyLines = dictionary["overview_polyline"] as? NSDictionary{
                                if let points = polyLines["points"] as? String{
                                    let path = GMSPath.init(fromEncodedPath: points)
                                    let polyline = GMSPolyline(path: path)
                                    polyline.strokeColor = UIColor.blue
                                    polyline.strokeWidth = 5.0
                                    polyline.map = self.mapView
                                }
                            }
                        }
                    }
                } else {
                    if let error = swiftyJson["error_message"].string {
                        AppUtils.showAlert(title: "Alert", message: error, viewController: self)
                    }
                }
            }
        }
    }
}
