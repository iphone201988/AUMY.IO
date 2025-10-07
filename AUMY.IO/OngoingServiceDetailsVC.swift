//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class OngoingServiceDetailsVC: UIViewController {
    
    @IBOutlet weak var startedIcon: UIImageView!
    @IBOutlet weak var completedIcon: UIImageView!
    @IBOutlet weak var disputeBtn: InterButton!
    @IBOutlet weak var serviceOngoingBtn: InterButton!
    @IBOutlet weak var serviceCompletedBtn: InterButton!
    @IBOutlet weak var serviceStatusLbl: InterLabel!
    
    var isCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isCompleted {
            startedIcon.image = UIImage(named: "Frame 427319894")
            completedIcon.image = UIImage(named: "Frame 427319894")
            disputeBtn.isHidden = true
            serviceOngoingBtn.isHidden = true
            serviceCompletedBtn.isHidden = false
            serviceStatusLbl.text = "Service Completed"
        } else {
            startedIcon.image = UIImage(named: "Frame 427319894-1")
            completedIcon.image = UIImage(named: "Frame 427319894-1")
            disputeBtn.isHidden = false
            serviceOngoingBtn.isHidden = false
            serviceCompletedBtn.isHidden = true
            serviceStatusLbl.text = "Ongoing Service"
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dispute(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: DisputeReasonVC.self, isAnimated: true)
    }
    
    @IBAction func serviceOngoing(_ sender: InterButton) {
        
    }
    
    @IBAction func serviceCompleted(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: ServiceCompletedVC.self, isAnimated: true)
    }
}
