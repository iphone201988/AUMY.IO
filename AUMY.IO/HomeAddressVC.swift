//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField
import CoreLocation
import GooglePlaces
import GoogleMaps

class HomeAddressVC: UIViewController {
    
    @IBOutlet weak var houseNoTF: DTTextField!
    @IBOutlet weak var streetTF: DTTextField!
    @IBOutlet weak var apartmentTF: DTTextField!
    @IBOutlet weak var floorTF: DTTextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLbl: InterLabel!
    @IBOutlet weak var stateCityLbl: InterLabel!
    
    let houseMessage        = NSLocalizedString("House number is required.", comment: "")
    let streetMessage         = NSLocalizedString("Street is required.", comment: "")
    let apartmentMessage         = NSLocalizedString("Apartment is required.", comment: "")
    let floorMessage         = NSLocalizedString("Floor is required.", comment: "")
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var mapZoomValue: Float = 15.0
    fileprivate var userDidMoveCamera = false
    fileprivate let geocoder = GMSGeocoder()
    fileprivate var autoPanTimer: CADisplayLink?
    fileprivate var panDirection: CGPoint = .zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([houseNoTF, streetTF, apartmentTF, floorTF])
        setEditableTextFieldFont([houseNoTF, streetTF, apartmentTF, floorTF])
        customPlaceHolder([houseNoTF, streetTF, apartmentTF, floorTF])
        setupMap()
        setupLocationManager()
    }
    
    private func setupMap() {
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func moveCameraToCurrentLocation(_ location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: mapZoomValue)
        mapView.animate(to: camera)
        placedMarker(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        reverseGeocode(lat: location.coordinate.latitude, long: location.coordinate.longitude)
    }
    
    func validateData() -> Bool {
        
        guard !houseNoTF.text!.isEmptyStr else {
            houseNoTF.showError(message: houseMessage)
            return false
        }
        
        guard !streetTF.text!.isEmptyStr else {
            streetTF.showError(message: streetMessage)
            return false
        }
        
        guard !apartmentTF.text!.isEmptyStr else {
            apartmentTF.showError(message: apartmentMessage)
            return false
        }
        
        guard !floorTF.text!.isEmptyStr else {
            floorTF.showError(message: floorMessage)
            return false
        }
        
        return true
    }
    
    @IBAction func saveAddress(_ sender: InterButton) {
        guard validateData() else { return }
        let params = [
            "address": "",
            "houseNumber": houseNoTF.text ?? "",
            "street": streetTF.text ?? "",
            "apartment": apartmentTF.text ?? "",
            "floor": floorTF.text ?? "",
            "lat":  CurrentLocation.latitude,
            "long":  CurrentLocation.longitude
        ] as [String : Any]
        Task { await completeOnboarding(params) }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HomeAddressVC: ServicesEvents {
    func dismissVC() {
        switch Constants.role {
        case .serviceProvider:
            let storyboard = AppStoryboards.main.storyboardInstance
            let rootVC = storyboard.instantiateViewController(withIdentifier: "ReviewedVC") as! ReviewedVC
            SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
            
        case .user:
            let storyboard = AppStoryboards.main.storyboardInstance
            let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarsVC") as! TabbarsVC
            SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
        }
    }
}

extension HomeAddressVC {
    fileprivate func completeOnboarding(_ params: [String: Any]) async {
        let res = await RemoteRequestManager.shared.uploadTask(endpoint: .completeOnboarding,
                                                               model: UserDetails.self,
                                                               params: params,
                                                               method: .put)
        await MainActor.run {
            switch res {
            case .failure(let err):
                Toast.show(message: err.localizedDescription)
                
            case .success:
                let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "AccountCreatedVC") as! AccountCreatedVC
                destVC.servicesEventsDelegate = self
                SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
            }
        }
    }
}

extension HomeAddressVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        CurrentLocation.latitude = location.coordinate.latitude
        CurrentLocation.longitude = location.coordinate.longitude
        if !userDidMoveCamera { // Only center map once
            moveCameraToCurrentLocation(location)
            userDidMoveCamera = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}

extension HomeAddressVC: GMSMapViewDelegate {
    
    func placedMarker(lat: CLLocationDegrees, long: CLLocationDegrees) {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.icon = UIImage(named: "markers")
        marker.isDraggable = true        // ✅ allow dragging
        marker.map = mapView
    }
    
    // User starts dragging marker
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        LogHandler.debugLog("🖐️ Marker drag started")
        // Optional bounce animation
        UIView.animate(withDuration: 0.2) {
            marker.iconView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    // Marker position changes while dragging
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        CurrentLocation.latitude = marker.position.latitude
        CurrentLocation.longitude = marker.position.longitude
        updatePanDirection(for: marker) // calculate direction but don’t move immediately
    }
    
    // User finished dragging marker
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        LogHandler.debugLog("📍 Marker drag ended at \(marker.position.latitude), \(marker.position.longitude)")
        UIView.animate(withDuration: 0.2) {
            marker.iconView?.transform = .identity
        }
        
        // Update coordinates globally
        CurrentLocation.latitude = marker.position.latitude
        CurrentLocation.longitude = marker.position.longitude
        
        stopAutoPan()
        // 🔁 Get address for new marker position
        reverseGeocode(lat: marker.position.latitude, long: marker.position.longitude)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let location = mapView.myLocation else { return false }
        moveCameraToCurrentLocation(location)
        LogHandler.debugLog("✅ My location button tapped")
        return true
    }
    
    // Optional: Also call geocode when map stops moving manually
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        LogHandler.debugLog("🗺️ Map idle at new position")
    }
    
    private func reverseGeocode(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, error in
            guard let self = self else { return }
            guard error == nil else {
                LogHandler.debugLog("❌ Geocoding error: \(error?.localizedDescription ?? "")")
                return
            }
            
            if let result = response?.firstResult(), let lines = result.lines {
                let fullAddress = lines.joined(separator: ", ")
                let components = fullAddress.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                let placeName = components.first ?? ""
                
                DispatchQueue.main.async {
                    self.addressLbl.text = fullAddress
                    self.houseNoTF.text = placeName
                    self.stateCityLbl.text = "\(result.subLocality ?? ""), \(result.locality ?? ""), \(result.administrativeArea ?? "")"
                }
                LogHandler.debugLog("📍 Address: \(fullAddress)")
            }
        }
    }
}

extension HomeAddressVC {
    
    /// Keep marker always visible while dragging
    func autoPanMapIfNeededO(for marker: GMSMarker) {
        let projection = mapView.projection
        let markerPoint = projection.point(for: marker.position)
        let mapBounds = mapView.bounds
        
        let padding: CGFloat = 40 // Distance from edge before panning starts
        var cameraUpdate: GMSCameraUpdate?
        
        // Move camera depending on which edge marker is near
        if markerPoint.x < padding {
            cameraUpdate = GMSCameraUpdate.scrollBy(x: -30, y: 0)
        } else if markerPoint.x > mapBounds.size.width - padding {
            cameraUpdate = GMSCameraUpdate.scrollBy(x: 30, y: 0)
        }
        
        if markerPoint.y < padding {
            cameraUpdate = GMSCameraUpdate.scrollBy(x: 0, y: -30)
        } else if markerPoint.y > mapBounds.size.height - padding {
            cameraUpdate = GMSCameraUpdate.scrollBy(x: 0, y: 30)
        }
        
        if let update = cameraUpdate {
            mapView.moveCamera(update)
        }
    }
}

extension HomeAddressVC {
    
    /// Determine which direction to pan based on marker’s position
    func updatePanDirection(for marker: GMSMarker) {
        let projection = mapView.projection
        let markerPoint = projection.point(for: marker.position)
        let bounds = mapView.bounds
        let padding: CGFloat = 40
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        if markerPoint.x < padding {
            x = -1
        } else if markerPoint.x > bounds.width - padding {
            x = 1
        }
        
        if markerPoint.y < padding {
            y = -1
        } else if markerPoint.y > bounds.height - padding {
            y = 1
        }
        
        panDirection = CGPoint(x: x, y: y)
        
        if panDirection != .zero {
            startAutoPan()
        } else {
            stopAutoPan()
        }
    }
    
    /// Starts smooth continuous camera movement
    func startAutoPan() {
        if autoPanTimer != nil { return } // already running
        autoPanTimer = CADisplayLink(target: self, selector: #selector(handleAutoPan))
        autoPanTimer?.add(to: .main, forMode: .common)
    }
    
    /// Stops camera movement
    func stopAutoPan() {
        autoPanTimer?.invalidate()
        autoPanTimer = nil
        panDirection = .zero
    }
    
    /// Moves map slowly every frame while dragging near edge
    @objc func handleAutoPan() {
        guard panDirection != .zero else { return }
        let speed: CGFloat = 2.0 // 👈 slower = smoother pan
        let update = GMSCameraUpdate.scrollBy(x: panDirection.x * speed, y: panDirection.y * speed)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        mapView.moveCamera(update)
        CATransaction.commit()
    }
}
