//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class CancelBookingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: ReasonCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    var servicesEventsDelegate: ServicesEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        servicesEventsDelegate?.dismissVC()
    }
    
}

// MARK: Delegates and DataSources
extension CancelBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReasonCell.identifier, for: indexPath) as! ReasonCell
        cell.spaciousTopView.isHidden = true
        cell.otherReasonView.isHidden = true
        cell.selectedIcon.image = UIImage(named: "Rectangle 392")
        if indexPath.row == 4 {
            cell.spaciousTopView.isHidden = false
            cell.otherReasonView.isHidden = false
            cell.selectedIcon.image = UIImage(named: "Group 60515")
        }
        return cell
    }
}
