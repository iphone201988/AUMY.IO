//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//


import UIKit
import CoreLocation

class LocationPermissionVC: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    @IBAction func allowLocationAccess(_ sender: InterButton) {
        // requestLocationPermission()
        SharedMethods.shared.pushToWithoutData(destVC: HomeAddressVC.self, isAnimated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // Request permission
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Show alert directing user to settings
            showLocationSettingsAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized
            LogHandler.debugLog("Location permission already granted")
        @unknown default:
            break
        }
    }
    
    private func showLocationSettingsAlert() {
        let alert = UIAlertController(
            title: "Location Access Needed",
            message: "Please allow location access in Settings to use this feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationPermissionVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            LogHandler.debugLog("User granted location access")
            // You can now fetch location if needed
            manager.startUpdatingLocation()
        case .denied, .restricted:
            LogHandler.debugLog("User denied location access")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        LogHandler.debugLog("User's current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogHandler.debugLog("Failed to get location: \(error.localizedDescription)")
    }
}
