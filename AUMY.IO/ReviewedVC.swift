//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class ReviewedVC: UIViewController {
    
    @IBOutlet weak var nameLbl: InterLabel!
    @IBOutlet weak var currentLocLbl: InterLabel!
    
    fileprivate let geocoder = GMSGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let name = UserDefaults.standard[.loggedUserDetails]?.name ?? ""
        if !name.isEmpty {
            nameLbl.text = "Hello, \(name) 👋 "
        } else {
            nameLbl.text = "Hello 👋 "
        }
        reverseGeocode()
    }
    
    @IBAction func createService(_ sender: InterButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarsVC") as! TabbarsVC
        SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
    }
}

extension ReviewedVC {
    private func reverseGeocode() {
        let lat = CurrentLocation.latitude
        let long = CurrentLocation.longitude
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, error in
            guard let self = self else { return }
            guard error == nil else {
                LogHandler.debugLog("❌ Geocoding error: \(error?.localizedDescription ?? "")")
                return
            }
            
            if let result = response?.firstResult(), let lines = result.lines {
                let fullAddress = lines.joined(separator: ", ")
                DispatchQueue.main.async {
                    self.currentLocLbl.text = "\(result.subLocality ?? ""), \(result.administrativeArea ?? "")"
                }
                LogHandler.debugLog("📍 Address: \(fullAddress)")
            }
        }
    }
}
