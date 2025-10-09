//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class BadgesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: BadgeCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    var badges = [["icon": "Mask group 1", "desc": "Complete 10 jobs to get this badge"],
                  ["icon": "Mask group-1-modified", "desc": "Use App for 3 months to get this badge"],
                  ["icon": "Mask group-3-modified", "desc": "Complete 25 jobs to get this badge"],
                  ["icon": "Mask group-2-modified", "desc": "Use App for 6 months to get this badge"],
                  ["icon": "Mask group-4-modified", "desc": "Complete 50 jobs to get this badge"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func back(_ sender: InterButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func withdrawalMoney(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: PaymentMethodVC.self, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension BadgesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        badges.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BadgeCell.identifier, for: indexPath) as! BadgeCell
        let details = badges[indexPath.row]
        let icon = details["icon"]
        let desc = details["desc"]
        cell.badgeIcon.image = UIImage(named: icon ?? "")
        cell.desc.text = desc
        cell.applyThisBadgeView.isHidden = true
        cell.spaciousViewHeight.constant = 10
        if indexPath.row == 0 {
            cell.applyThisBadgeView.isHidden = false
            cell.spaciousViewHeight.constant = 12
        }
        return cell
    }
}
