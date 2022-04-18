

import Foundation
import CoreLocation

class LocationHelper : NSObject{
    private static var _obj : LocationHelper? = nil
    var locationManager: CLLocationManager!
    var getCurrentLocation :  ((_ location : CLLocation)->Void)? = nil
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    class var sharedInstance:LocationHelper{
        get{
            if _obj == nil{
                _obj = LocationHelper()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
    }
}

extension LocationHelper : CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        getCurrentLocation!(userLocation)
        
        
    }
    
    
    
}
