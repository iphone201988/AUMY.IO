//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ServicesCreatedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    @IBAction func close(_ sender: InterButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirm(_ sender: InterButton) {
        self.dismiss(animated: true)
    }
    
}

