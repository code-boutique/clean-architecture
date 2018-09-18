import Foundation
import CoreLocation

class LocationWorker:BaseWorker<Void, Location, LocationError> {
    
    private let locationManager:LocationManager
    private let accuracy:CLLocationAccuracy
    private var location:CLLocation?
    private let delegate:LocationDelegate
    
    init(locationManager:LocationManager = LocationManager(), accuracy:CLLocationAccuracy = kCLLocationAccuracyBest, delegate:LocationDelegate = LocationDelegate()) {
        self.locationManager = locationManager
        self.accuracy = accuracy
        self.delegate = delegate
    }
    
    override func job(input: Void?, completion: @escaping ((WorkerResult<Location, LocationError>) -> Void)) {
        switch locationManager.authorizationStatus() {
        case .notDetermined:
            completion(WorkerResult.failure(LocationError.noLocationPermission))
            return
        case .restricted:
            completion(WorkerResult.failure(LocationError.restrictedLocationUsage))
            return
        case .denied:
            if !CLLocationManager.locationServicesEnabled() {
                if !CLLocationManager.locationServicesEnabled() {
                    completion(WorkerResult.failure(LocationError.noLocationEnabled))
                }else{
                    completion(WorkerResult.failure(LocationError.deniedLocationUsage))
                }
            }else{
                completion(WorkerResult.failure(LocationError.deniedLocationUsage))
            }
            return
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
            
        }
        delegate.completion = completion
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = accuracy;
        locationManager.startUpdatingLocation()
    }
}

typealias LocationCompletionFunction = ((WorkerResult<Location, LocationError>) -> Void)
class LocationDelegate:NSObject,CLLocationManagerDelegate {
    
    var completion:LocationCompletionFunction?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            manager.stopUpdatingLocation()
            manager.delegate = nil
            let location:CLLocation = locations.first!
            completion?(WorkerResult.success(Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if error.code == 0 && error.domain == "kCLErrorDomain" {
            completion?(WorkerResult.failure(LocationError.noLocation))
        }else{
            completion?(WorkerResult.failure(LocationError.unknown))
        }
    }
}
