//
//  LocationManager.swift
//  medium_weather_app
//
//  Created by jules bernard on 31.10.25.
//

import CoreLocation
import Combine
import SwiftUI


class LocationService: NSObject,ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocation?
    var locationVM: LocationVM
    
    init(locationVM: LocationVM){
        self.locationVM = locationVM
        super.init()
        manager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print(manager.requestLocation())
            break
            
        case .restricted, .denied:
            print(manager.authorizationStatus)
            print("location auth are restricted or denied")
            break
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
//    Those 2 functions NEED to be explicitely present here
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {return}
        let coord = "\(loc.coordinate.latitude) \(loc.coordinate.longitude)"
        locationVM.latiLongi = [loc.coordinate.latitude, loc.coordinate.longitude]
//        locationVM.latiLongi = [52.52, 13.419]
        locationVM.midText = coord
        locationVM.reverseGeocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location error:", error.localizedDescription)
        }
    
}
