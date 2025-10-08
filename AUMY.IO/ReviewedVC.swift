//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ReviewedVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createService(_ sender: InterButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let rootVC = storyboard.instantiateViewController(withIdentifier: "TabbarsVC") as! TabbarsVC
        SharedMethods.shared.navigateToRootVC(rootVC: rootVC)
    }
    
}
