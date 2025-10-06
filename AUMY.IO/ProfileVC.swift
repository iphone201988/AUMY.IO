//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: SettingOptionCell.identifier)
        }
    }
    
    var options = [["icon": "basil_edit-outline", "option": "Edit Profile"],
                   ["icon": "streamline-plump_password-lock", "option": "Change Password"],
                   ["icon": "MapPinLine 2", "option": "Change Address"],
                   ["icon": "solar_star-linear", "option": "Your Reviews"],
                   ["icon": "BellRinging", "option": "Notification"],
                   ["icon": "ic_outline-privacy-tip", "option": "Privacy Policy"],
                   ["icon": "solar_logout-2-broken", "option": "Log Out"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

// MARK: Delegates and DataSources
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionCell.identifier, for: indexPath) as! SettingOptionCell
        let optionDetails = options[indexPath.row]
        let iconName = optionDetails["icon"]
        let title = optionDetails["option"]
        cell.optionLbl.textColor = .white
        cell.icon.image = UIImage(named: iconName ?? "")
        cell.optionLbl.text = title
        cell.underlineView.isHidden = false
        cell.forwardIcon.isHidden = false
        cell.enableDisableNotificationView.isHidden = true
        
        if title == "Notification" {
            cell.forwardIcon.isHidden = true
            cell.enableDisableNotificationView.isHidden = false
        }
        
        if title == "Log Out" {
            cell.optionLbl.textColor = UIColor(named: "FF4141")
            cell.underlineView.isHidden = true
        }
        
        return cell
    }
}
