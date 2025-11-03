import CoreLocation

class LocationManager: ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var authStatus: CLAuthorizationStatus?
    @Published var location: CLLocation?
}