//
//  LocationVC.swift
//  WoWonder
//
//  Created by Abdul Moid on 18/01/2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationVC: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    private let locationManager = CLLocationManager()
    var delegate:sendLocationProtocol?
    var latitude:Double? = 0.0
    var longitude:Double? = 0.0
    
    let marker = GMSMarker()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        sendButton.backgroundColor = .ButtonColor
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        locManager.requestWhenInUseAuthorization()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
            log.verbose("Lat = \(currentLocation.coordinate.latitude)")
            log.verbose("long = \(currentLocation.coordinate.longitude)")
            self.latitude = currentLocation.coordinate.latitude
            self.longitude = currentLocation.coordinate.longitude
        }
        
        let camera = GMSCameraPosition(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0, zoom: 50)
        mapView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: self.latitude ?? 0 , longitude: self.longitude ?? 0)
        marker.map = mapView
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        self.delegate?.sendLocation(lat: self.latitude ?? 00, long: self.longitude ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
//1
extension LocationVC: CLLocationManagerDelegate {
  // 2
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.startUpdatingLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    // 7
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

    // 8
    locationManager.stopUpdatingLocation()
  }
}

extension LocationVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.latitude = position.target.latitude
        self.longitude = position.target.longitude
        marker.position = position.target
    }
}
