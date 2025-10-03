import CoreLocation

final class LocationPermissionHelper: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?

    var onStatusChange: ((CLAuthorizationStatus) -> Void)?

    func requestLocationAccess() {
        let manager = CLLocationManager()
        manager.delegate = self
        locationManager = manager // Keep strong reference
    }

    // iOS 14+
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        onStatusChange?(status)
    }

    // iOS 13 and below fallback
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onStatusChange?(status)
    }
}
