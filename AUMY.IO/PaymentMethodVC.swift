//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: PaymentMethodCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    fileprivate var options = [
        ["icon": "Group 54", "title": "Stripe"],
        ["icon": "Group 55", "title": "Mercado Pago"]
    ]
    
    var selectedOption = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: InterButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: BookingConfirmedVC.self, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension PaymentMethodVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCell.identifier, for: indexPath) as! PaymentMethodCell
        let optionDetails = options[indexPath.row]
        cell.icon.image = UIImage(named: optionDetails["icon"] ?? "")
        cell.title.text = optionDetails["title"]
        if selectedOption == indexPath.row {
            cell.selectedIcon.isHidden = false
        } else {
            cell.selectedIcon.isHidden = true
        }
        
        if indexPath.row == 1 {
            cell.underlineView.isHidden = true
        } else {
            cell.underlineView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = indexPath.row
        self.tableView.reloadData()
    }
}

