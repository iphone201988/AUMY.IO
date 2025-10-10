//
//  RescheduleBookingVC.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class JobRequestDetailVC: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var jobCompletedView: UIView!
    @IBOutlet weak var clientView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        jobCompletedView.isHidden = true
        clientView.isHidden = true
        addressView.isHidden = true
        dateView.isHidden = true
        timeView.isHidden = true
        
        if Constants.role == .serviceProvider {
            clientView.isHidden = false
            addressView.isHidden = false
            dateView.isHidden = false
            timeView.isHidden = false
        } else {
            jobCompletedView.isHidden = false
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectRequest(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: RejectJobVC.self, isAnimated: true)
    }
    
    @IBAction func acceptRequest(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: BookingAcceptedVC.self, isAnimated: true)
    }
}
