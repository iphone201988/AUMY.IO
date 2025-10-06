//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class BookingDetailsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBooking(_ sender: InterButton) {
        let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "CancelBookingVC") as! CancelBookingVC
        destVC.servicesEventsDelegate = self
        SharedMethods.shared.pushTo(destVC: destVC, isAnimated: true)
    }
    
    @IBAction func reschedule(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: RescheduleBookingVC.self, isAnimated: true)
    }
    
}

extension BookingDetailsVC: ServicesEvents {
    func dismissVC() {
        let storyboard = AppStoryboards.main.storyboardInstance
        let destVC = storyboard.instantiateViewController(withIdentifier: "CancelConfirmPopupVC") as! CancelConfirmPopupVC
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
    }
}
