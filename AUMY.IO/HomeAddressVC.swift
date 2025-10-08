//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField

class HomeAddressVC: UIViewController {
    
    @IBOutlet weak var houseNoTF: DTTextField!
    @IBOutlet weak var streetTF: DTTextField!
    @IBOutlet weak var apartmentTF: DTTextField!
    @IBOutlet weak var floorTF: DTTextField!
    
    let houseMessage        = NSLocalizedString("House number is required.", comment: "")
    let streetMessage         = NSLocalizedString("Street is required.", comment: "")
    let apartmentMessage         = NSLocalizedString("Apartment is required.", comment: "")
    let floorMessage         = NSLocalizedString("Floor is required.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatPlaceholderFont([houseNoTF, streetTF, apartmentTF, floorTF])
        setEditableTextFieldFont([houseNoTF, streetTF, apartmentTF, floorTF])
        customPlaceHolder([houseNoTF, streetTF, apartmentTF, floorTF])
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
        let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "AccountCreatedVC") as! AccountCreatedVC
        destVC.servicesEventsDelegate = self
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
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
