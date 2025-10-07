//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: AvailableServicesCell.identifier)
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
    
    @IBAction func sortBy(_ sender: UIButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let destVC = storyboard.instantiateViewController(withIdentifier: "SortByVC") as! SortByVC
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AvailableServicesCell.identifier, for: indexPath) as! AvailableServicesCell
        return cell
    }
}
