//
//  SettingOptionCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class SettingOptionCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionLbl: InterLabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var forwardIcon: UIImageView!
    @IBOutlet weak var thumbView: NSLayoutConstraint!
    @IBOutlet weak var enableBtn: UIButton!
    @IBOutlet weak var disableBtn: UIButton!
    @IBOutlet weak var enableDisableNotificationView: UIView!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func enableNotification(_ sender: UIButton) {
        thumbView.priority = UILayoutPriority(998)
        enableDisableNotificationView.backgroundColor = UIColor(named: "374151")
    }
    
    @IBAction func disableNotification(_ sender: UIButton) {
        thumbView.priority = UILayoutPriority(996)
        enableDisableNotificationView.backgroundColor = .lightGray
    }
}
