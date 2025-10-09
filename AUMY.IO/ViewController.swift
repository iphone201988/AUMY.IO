//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func serviceProvider(_ sender: InterButton) {
        Constants.role = .serviceProvider
        SharedMethods.shared.pushToWithoutData(destVC: LoginVC.self, isAnimated: true)
    }
    
    @IBAction func getStarted(_ sender: InterButton) {
        Constants.role = .user
        SharedMethods.shared.pushToWithoutData(destVC: LoginVC.self, isAnimated: true)
    }

}

