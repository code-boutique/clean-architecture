enum LocationError:Error, Equatable {
    case noLocationPermission, restrictedLocationUsage, noLocationEnabled, deniedLocationUsage, noLocation, unknown
}

