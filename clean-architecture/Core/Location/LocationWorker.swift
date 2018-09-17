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
    
    override func run(input: Void?, completion: @escaping ((WorkerResult<Location, LocationError>) -> Void)) {
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
        //TODO: maybe injected
        delegate.completion = completion
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = accuracy;
        locationManager.startUpdatingLocation()
    }
    
//    override func run(input: Void?) -> Promise<Location> {
//        //TODO: ojo que sino hay location no revienta???? simular haber que casos se dan....
//        let promise = CLLocationManager.requestLocation().firstValue.map { (location:CLLocation) -> Location in
//            let lm = CLLocationManager()
//            lm.stopUpdatingLocation()
//            let cllocation = location.coordinate
//            return Location(latitude: cllocation.latitude, longitude: cllocation.longitude)
//        }
//        return promise
////        return CLLocationManager.promise().compactMap { (locations:Array<CLLocation>) -> Location in
////            let lm = CLLocationManager()
////            lm.stopUpdatingLocation()
////            if self.location == nil {
////                let cllocation = locations.first!.coordinate
////                return Location(latitude: cllocation.latitude, longitude: cllocation.longitude)
////            }
////        }
////        return CLLocationManager.promise().map { (locations) -> Location in
////            let cllocation = locations.first!.coordinate
////            return Location(latitude: cllocation.latitude, longitude: cllocation.longitude)
////        }
//    }
}

extension CLLocationManager {
    func promise() {
    
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
