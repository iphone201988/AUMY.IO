//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class TabbarsVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let items = tabBar.items {
               for item in items {
                   // Move image down (positive top inset pushes it downward)
                   item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                   
                   // Optional: hide title (if you want only icon centered lower)
                   // item.title = nil
               }
           }
    }
}

