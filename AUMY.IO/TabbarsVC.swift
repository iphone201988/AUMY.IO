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
        
        addTopShadowToTabBar()
        applyValidationForTabItems()
    }
    
    func applyValidationForTabItems() {
        guard let viewControllers = viewControllers, viewControllers.count > 1 else { return }
        
        let storyboard = AppStoryboards.main.storyboardInstance
        let newVC: UIViewController
        
        if Constants.role == .serviceProvider {
            newVC = storyboard.instantiateViewController(withIdentifier: "YourServicesVC")
        } else {
            newVC = storyboard.instantiateViewController(withIdentifier: "ServicesVC")
        }
        
        // ✅ Preserve old tab bar item (icon, title, tag)
        let oldTabBarItem = viewControllers[1].tabBarItem
        newVC.tabBarItem = oldTabBarItem
        
        // Replace only that controller
        var updatedControllers = viewControllers
        updatedControllers[1] = newVC
        self.viewControllers = updatedControllers
    }
    
    private func addTopShadowToTabBar() {
        // guard let tabBar = self.tabBar else { return }
        
        // Remove default shadow (if any)
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        // Add custom shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -8) // shadow above
        tabBar.layer.shadowRadius = 8
        
        // Important: set shadowPath manually to match full width
        let shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                   y: 0, // how far above the bar the shadow should extend
                                                   width: tabBar.bounds.width,
                                                   height: 2))
        tabBar.layer.shadowPath = shadowPath.cgPath
    }
}

