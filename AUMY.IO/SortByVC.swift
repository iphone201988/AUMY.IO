//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class SortByVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: SortByOptionCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    fileprivate var sortByOptions = [
        ["icon": "Money", "title": "Price", "value": "High to low"],
        ["icon": "Money", "title": "Price", "value": "Low to high"],
        ["icon": "solar_star-linear", "title": "Rating", "value": "High to low"],
        ["icon": "MapPinLine 2", "title": "Near you", "value": ""]
    ]
    
    var selectedOption = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    @IBAction func apply(_ sender: InterButton) {
        self.dismiss(animated: true)
    }
}

// MARK: Delegates and DataSources
extension SortByVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortByOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortByOptionCell.identifier, for: indexPath) as! SortByOptionCell
        let optionDetails = sortByOptions[indexPath.row]
        cell.icon.image = UIImage(named: optionDetails["icon"] ?? "")
        cell.title.text = optionDetails["title"]
        let value = optionDetails["value"] ?? ""
        cell.value.text = value
        if value.isEmpty {
            cell.dotIcon.isHidden = true
        } else {
            cell.dotIcon.isHidden = false
        }
        if selectedOption == indexPath.row {
            cell.selectedIcon.isHidden = false
        } else {
            cell.selectedIcon.isHidden = true
        }
        
        if indexPath.row == 3 {
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

