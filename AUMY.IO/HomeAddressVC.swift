//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class HomeAddressVC: UIViewController {
    
    @IBOutlet weak var houseNoTF: DTTextField!
    @IBOutlet weak var streetTF: DTTextField!
    @IBOutlet weak var apartmentTF: DTTextField!
    @IBOutlet weak var floorTF: DTTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLbl: InterLabel!
    @IBOutlet weak var stateCityLbl: InterLabel!
    
    let houseMessage        = NSLocalizedString("House number is required.", comment: "")
    let streetMessage         = NSLocalizedString("Street is required.", comment: "")
    let apartmentMessage         = NSLocalizedString("Apartment is required.", comment: "")
    let floorMessage         = NSLocalizedString("Floor is required.", comment: "")
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private var currentAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([houseNoTF, streetTF, apartmentTF, floorTF])
        setEditableTextFieldFont([houseNoTF, streetTF, apartmentTF, floorTF])
        customPlaceHolder([houseNoTF, streetTF, apartmentTF, floorTF])
        setupMap()
        setupLocationManager()
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

extension HomeAddressVC: MKMapViewDelegate {
    
    // MARK: - Setup Map & Location
    private func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        // Add a “current location” button
        let locateButton = UIButton(type: .system)
        locateButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locateButton.tintColor = .systemBlue
        locateButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        locateButton.layer.cornerRadius = 25
        locateButton.frame = CGRect(x: mapView.frame.width - 70, y: mapView.frame.height - 90, width: 50, height: 50)
        locateButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        locateButton.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        mapView.addSubview(locateButton)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func moveToCurrentLocation() {
        guard let coordinate = currentCoordinate else { return }
        centerMap(on: coordinate)
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    private func addMarker(at coordinate: CLLocationCoordinate2D) {
        if let existing = currentAnnotation {
            mapView.removeAnnotation(existing)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Your Location"
        mapView.addAnnotation(annotation)
        currentAnnotation = annotation
    }
}

extension HomeAddressVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        CurrentLocation.latitude = location.coordinate.latitude
        CurrentLocation.longitude = location.coordinate.longitude
        
        centerMap(on: location.coordinate)
        addMarker(at: location.coordinate)
        
        // Optional: reverse-geocode
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let placemark = placemarks?.first else { return }
            self.addressLbl.text = placemark.name ?? ""
            self.stateCityLbl.text = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Toast.show(message: "Unable to fetch location: \(error.localizedDescription)")
    }
}
