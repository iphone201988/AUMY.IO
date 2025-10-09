//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class EarningsDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: TransactionsHistoryCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
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
extension EarningsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsHistoryCell.identifier, for: indexPath) as! TransactionsHistoryCell
        return cell
    }
}
