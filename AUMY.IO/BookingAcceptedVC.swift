//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class BookingAcceptedVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: InterButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
