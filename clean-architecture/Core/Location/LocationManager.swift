import CoreLocation

class LocationManager: CLLocationManager {
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}

