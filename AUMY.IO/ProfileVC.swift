//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var earningsTopSpaciousView: UIView!
    @IBOutlet weak var earningsView: UIView!
    @IBOutlet weak var earningsBottomSpaciousView: UIView!
    @IBOutlet weak var topPlusView: UIView!
    @IBOutlet weak var bottomPlusView: UIView!
    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: SettingOptionCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    var options = [["icon": "basil_edit-outline", "option": "Edit Profile"],
                   ["icon": "streamline-plump_password-lock", "option": "Change Password"],
                   ["icon": "MapPinLine 2", "option": "Change Address"],
                   ["icon": "solar_star-linear", "option": "Your Reviews"],
                   ["icon": "BellRinging", "option": "Notification"],
                   ["icon": "cil_badge", "option": "Badges"],
                   ["icon": "ic_outline-privacy-tip", "option": "Privacy Policy"],
                   ["icon": "solar_logout-2-broken", "option": "Log Out"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Constants.role == .serviceProvider {
            earningsTopSpaciousView.isHidden = false
            earningsBottomSpaciousView.isHidden = true
            earningsView.isHidden = false
            topPlusView.isHidden = true
            bottomPlusView.isHidden = false
            badgeIcon.isHidden = false
            profilePic.image = UIImage(named: "Mask group 2")
        } else {
            earningsTopSpaciousView.isHidden = true
            earningsBottomSpaciousView.isHidden = false
            earningsView.isHidden = true
            topPlusView.isHidden = false
            bottomPlusView.isHidden = true
            badgeIcon.isHidden = true
            profilePic.image = UIImage(named: "Group 73")
        }
    }
    
    @IBAction func notification(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: NotificationVC.self, isAnimated: true)
    }
    
    @IBAction func withdrawalDetails(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: EarningsDetailsVC.self, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Constants.role == .serviceProvider {
            return UITableView.automaticDimension
        } else {
            if indexPath.row == 5 {
                return .zero
            } else {
                return UITableView.automaticDimension
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionDetails = options[indexPath.row]
        let title = optionDetails["option"]
        
        if title == "Edit Profile" {
            SharedMethods.shared.pushToWithoutData(destVC: EditProfileVC.self, isAnimated: true)
        }
        
        if title == "Change Password" {
            SharedMethods.shared.pushToWithoutData(destVC: ChangePasswordVC.self, isAnimated: true)
        }
        
        if title == "Change Address" {
            SharedMethods.shared.pushToWithoutData(destVC: ChangeAddressVC.self, isAnimated: true)
        }
        
        if title == "Your Reviews" {
            SharedMethods.shared.pushToWithoutData(destVC: YourReviewsVC.self, isAnimated: true)
        }
        
        if title == "Badges" {
            SharedMethods.shared.pushToWithoutData(destVC: BadgesVC.self, isAnimated: true)
        }
    }
}
