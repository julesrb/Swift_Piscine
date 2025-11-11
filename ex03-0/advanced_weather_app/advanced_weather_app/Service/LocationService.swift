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
    @Published var locationVM: LocationVM
    
    init(locationVM: LocationVM){
        self.locationVM = locationVM
        super.init()
        manager.delegate = self
    }
    
    func checkAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("location auth is when is use OK")
            manager.requestLocation()
            break
            
        case .restricted, .denied:
            print("location auth are restricted or denied")
            break
            
        case .notDetermined:
            print("location auth is not determined")
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse ||
               manager.authorizationStatus == .authorizedAlways {
                manager.requestLocation()
            }
        }
    
//    Those 2 functions NEED to be explicitely present here
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else {return}
        locationVM.latiLongi = [loc.coordinate.latitude, loc.coordinate.longitude]
//        locationVM.latiLongi = [52.52, 13.419]
//        locationVM.latiLongi = [0, 0]
        locationVM.reverseGeocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location error:", error.localizedDescription)
        }
    
}
