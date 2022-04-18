//
//  MapController.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 12/28/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ZKProgressHUD

class MapController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextViewDelegate{
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var searchTextView: UITextView!
    @IBOutlet var doneBtn: RoundButton!
    @IBOutlet var myLocation: UIButton!
    @IBOutlet var nearByBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var camera:GMSCameraPosition!
    var circleView = UIView()
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var geoCodeResult = [[String:Any]]()
    var delegate: getAddressDelegate?
    
    var address = ""
    var marker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.searchView.backgroundColor =  UIColor.hexStringToUIColor(hex: ControlSettings.appMainColor)
        self.myLocation.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.nearByBtn.setTitleColor(UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor), for: .normal)
        self.myLocation.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.nearByBtn.tintColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.doneBtn.backgroundColor = UIColor.hexStringToUIColor(hex: ControlSettings.buttonColor)
        self.mapView.delegate = self
        self.searchTextView.delegate = self
        //        self.textView.text = "Search..."
        self.mapView?.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        self.camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        self.mapView.camera = camera
        self.mapView?.animate(to: camera)
        DispatchQueue.main.async {
            let position = CLLocationCoordinate2DMake(location?.coordinate.latitude ?? 0.0,location?.coordinate.longitude ?? 0.0)
            self.mapView.clear()
            self.marker = GMSMarker(position: position)
            //            self.marker?.title = "Hello World"
            self.marker?.map = self.mapView
            
        }
        //        self.mapView.settings.myLocationButton = true
        self.locationManager.stopUpdatingLocation()
        
    }
    
    
    @objc func circlePerClick(_ sender : AnyObject)  {
        print("\(centerMapCoordinate!)")
    }
    
    //     GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.isMyLocationEnabled = true
        locationManager.stopUpdatingLocation()
        let latitude1 = self.mapView.camera.target.latitude
        let longitude1 = self.mapView.camera.target.longitude
        
        GetAddress1(Lat: latitude1, Long: longitude1)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = self.mapView.camera.target.latitude
        let longitude = self.mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        print("center point :-> \(centerMapCoordinate)")
        self.latitude = centerMapCoordinate.latitude
        self.longitude = centerMapCoordinate.longitude
        let coordinate = self.mapView.projection.coordinate(for: circleView.center)
        
    }
    
    
    func createCircleView() {
        self.circleView.backgroundColor = UIColor.black  //red.withAlphaComponent(0.5)
        view.addSubview(circleView)
        view.bringSubviewToFront(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add Constraint to need x, y, widht, height
        let  heightConstraint =  NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: self.mapView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: self.mapView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
        
        self.view.layoutIfNeeded()
        
        circleView.layer.cornerRadius = circleView.bounds.size.width/2   //CGRect.width(circleView.frame)/2
        circleView.clipsToBounds = true
        circleView.layer.masksToBounds = true
        
    }
    
    func GetAddress1(Lat:Double,Long:Double){
        
        GeoCodeManager.sharedInstance.geoCode(type: "latlng", lat: Lat, lng: Long) { (success, authError, error) in
            if (success != nil){
                if let address = success?.results[0]["formatted_address"] as? String{
                    self.address = address
                    self.marker?.title = address
                }
            }
            else if (authError != nil){
                print(authError?.error_message ?? "")
                //                Globals.showAlertWith(title: "", message: authError?.error_message ?? "")
            }
            else if error != nil{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reverseGeoCode(address:String){
        ZKProgressHUD.show(NSLocalizedString("Loading", comment: "Loading"))
        
        ReverseGeoCodeManager.sharedInstance.reverseGeoCode(address: address) { (success, authError, error) in
            if (success != nil){
                var lat = 0.0
                var lng = 0.0
                if let geometry  = success?.results[0]["geometry"] as? [String:Any]{
                    if let location = geometry["location"] as? [String:Any]{
                        if let lats = location["lat"] as? Double{
                            lat = lats
                        }
                        if let lngs = location["lng"] as? Double{
                            lng = lngs
                        }
                        self.locationManager.startUpdatingLocation()
                        let camera = GMSCameraPosition.camera(withLatitude: (lat), longitude: (lng), zoom: 12.0)
                        self.mapView.camera = camera
                        self.mapView?.animate(to: camera)
                        self.locationManager.stopUpdatingLocation()
                        self.mapView.clear()
                        let position = CLLocationCoordinate2DMake(lat,lng)
                        self.marker = GMSMarker(position: position)
                        //                    self.marker?.title = "Hello World"
                        self.marker?.map = self.mapView
                        ZKProgressHUD.dismiss()
                    }
                }
                if let addresss = success?.results[0]["formatted_address"] as? String{
                    self.address = addresss
                    self.marker?.title = addresss
                }
            }
            else if (authError != nil){
                print(authError?.error_message ?? "")
                ZKProgressHUD.dismiss()
                //                Globals.showAlertWith(title: "", message: authError?.error_message ?? "")
            }
            else if error != nil{
                print(error?.localizedDescription ?? "")
                ZKProgressHUD.dismiss()
                //                Globals.showAlertWith(title: "", message: error?.localizedDescription ?? "")
                
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (self.searchTextView.text.isEmpty == true) || (self.searchTextView.text == nil) || (self.searchTextView.text == "search...") || (self.searchTextView.text == "") || (self.searchTextView.text == " "){
            
        }
        else{
            self.reverseGeoCode(address: self.searchTextView.text)
        }
    }
    
    
    @IBAction func NearBy(_ sender: Any) {
    }
    
    @IBAction func MyLocation(_ sender: Any) {
        let lat =  self.mapView.myLocation?.coordinate.latitude ?? 0.0
        let lng = self.mapView.myLocation?.coordinate.longitude ?? 0.0
        self.locationManager.startUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (lat), longitude: (lng), zoom: 13.0)
        self.mapView.camera = camera
        self.mapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        let position = CLLocationCoordinate2DMake(lat,lng)
        self.mapView.clear()
        self.marker = GMSMarker(position: position)
        //        self.marker?.title = "Hello World"
        self.marker?.map = self.mapView
    }
    
    @IBAction func Done(_ sender: Any) {
        if (self.address == ""){
            
        }
        else{
            self.dismiss(animated: true) {
                self.delegate?.getAddress(address: self.address)
            }
        }
    }
    
}
