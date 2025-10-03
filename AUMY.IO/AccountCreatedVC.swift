//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class AccountCreatedVC: UIViewController {

    var servicesEventsDelegate: ServicesEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray.withAlphaComponent(0.5)
    }

    @IBAction func home(_ sender: InterButton) {
        servicesEventsDelegate?.dismissVC()
    }
}

