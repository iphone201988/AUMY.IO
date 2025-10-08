//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class AboutYourServiceVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func continueTo(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: LocationPermissionVC.self, isAnimated: true)
    }
    
}
