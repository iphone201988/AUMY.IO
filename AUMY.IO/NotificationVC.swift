//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: NotificationCell.identifier)
            tableView.registerCellFromNib(cellID: TimeHeaderCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    var notifications = [
        ["date": "Today",
         "notifications": [
            ["title": "Upcoming Booking",
             "desc": "Today is your booking at 12:00PM please be ready",
             "highlight": "12:00PM"],
            
            ["title": "Review",
             "desc": "James gave you a review",
             "highlight": "James"]
         ]
        ],
        ["date": "Yesterday",
         "notifications": [
            ["title": "Booking Confirmed",
             "desc": "Your booking was confirmed by James",
             "highlight": "James"],
            
            ["title": "Reschedule Confirmed",
             "desc": "Your booking is Reschedule to Wed, Aug 12 | 10:00AM",
             "highlight": "Wed, Aug 12 | 10:00AM"]
         ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Delegates and DataSources
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TimeHeaderCell.identifier) as! TimeHeaderCell
        let dict = notifications[section]
        headerCell.headerTitleLbl.text = dict["date"] as? String
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        
        let dict = notifications[indexPath.section]
        let arr = dict["notifications"] as? NSArray ?? []
        let obj = arr[indexPath.row] as? NSDictionary ?? [:]
        let title = obj["title"] as? String ?? ""
        cell.titleLbl.text = title
        let desc = obj["desc"] as? String ?? ""
        let highlightText = obj["highlight"] as? String ?? ""
        
        let attributedString = NSMutableAttributedString(
            string: desc,
            attributes: [
                .foregroundColor: UIColor(named: "374151_40") ?? .darkGray,
                .font: UIFont(name: "Inter-Light", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .light)
            ]
        )
        
        if let range = desc.range(of: highlightText) {
            let nsRange = NSRange(range, in: desc)
            attributedString.addAttributes([
                .foregroundColor: UIColor(named: "374151") ?? .darkGray,
                .font: UIFont(name: "Inter-Light", size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .light)
            ], range: nsRange)
        }
        
        cell.descLbl.attributedText = attributedString
        
        return cell
    }
}
