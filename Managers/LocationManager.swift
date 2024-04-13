import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var locationUpdated = false
    @Published var isAuthorized: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest // Set desired accuracy
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestAlwaysAuthorization() // Requesting always authorization
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        locationUpdated = true
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
        isLoading = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
                case .notDetermined:
                    requestLocation() // Requests authorization when not determined
                case .restricted, .denied:
                    isAuthorized = false
                    print("Location authorization denied or restricted")
                case .authorizedAlways, .authorizedWhenInUse:
                    isAuthorized = true
                    print("Location authorized")
                    manager.startUpdatingLocation()
                @unknown default:
                    fatalError("Unhandled authorization status")
            }
        }

    
    func checkLocationAuthorization() {
        switch manager.authorizationStatus {
                    // ... other cases ...
                    case .authorizedAlways, .authorizedWhenInUse:
                        isAuthorized = true
                        manager.startUpdatingLocation()
                    default:
                        isAuthorized = false
                }
    }
    
    var authorizationStatus: CLAuthorizationStatus {
            return manager.authorizationStatus
        }

}
