//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class UpcomingServiceDetailsVC: UIViewController {
    
    @IBOutlet weak var serviceStatusLbl: InterLabel!
    @IBOutlet weak var bookedIcon: UIImageView!
    @IBOutlet weak var onTheWayIcon: UIImageView!
    @IBOutlet weak var startedIcon: UIImageView!
    @IBOutlet weak var completedIcon: UIImageView!
    @IBOutlet weak var mapDirectionBtn: InterButton!
    @IBOutlet weak var onTheWayBtn: InterButton!
    @IBOutlet weak var startedServiceBtn: InterButton!
    @IBOutlet weak var serviceCompletedBtn: InterButton!
    @IBOutlet weak var actionBtnsView: UIStackView!
    @IBOutlet weak var actionBtnsViewHeight: NSLayoutConstraint!
    
    var event: Events = .booked
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapDirectionBtn.isHidden = true
        onTheWayBtn.isHidden = true
        startedServiceBtn.isHidden = true
        serviceCompletedBtn.isHidden = true
        actionBtnsView.isHidden = false
        actionBtnsViewHeight.constant = 51.0
        
        switch event {
        case .booked:
            bookedIcon.image = UIImage(named: "Frame 427319894")
            mapDirectionBtn.isHidden = false
            onTheWayBtn.isHidden = false
            
        case .onTheWay:
            bookedIcon.image = UIImage(named: "Frame 427319894")
            onTheWayIcon.image = UIImage(named: "Frame 427319894")
            mapDirectionBtn.isHidden = false
            startedServiceBtn.isHidden = false
            
        case .started:
            bookedIcon.image = UIImage(named: "Frame 427319894")
            onTheWayIcon.image = UIImage(named: "Frame 427319894")
            startedIcon.image = UIImage(named: "Frame 427319894")
            serviceCompletedBtn.isHidden = false
            
        case .completed:
            bookedIcon.image = UIImage(named: "Frame 427319894")
            onTheWayIcon.image = UIImage(named: "Frame 427319894")
            startedIcon.image = UIImage(named: "Frame 427319894")
            completedIcon.image = UIImage(named: "Frame 427319894")
            actionBtnsView.isHidden = true
            actionBtnsViewHeight.constant = 0.0
            
        default: break
            
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mapDirection(_ sender: UIButton) {
    }
    
    @IBAction func onTheWay(_ sender: UIButton) {
    }
    
    @IBAction func startedService(_ sender: UIButton) {
    }
    
    @IBAction func serviceCompleted(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: ServiceCompletedVC.self, isAnimated: true)
    }
    
}
