//
//  BadgeCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 09/10/25.
//

import UIKit

class BadgeCell: UITableViewCell {

    @IBOutlet weak var badgeIcon: UIImageView!
    @IBOutlet weak var desc: InterLabel!
    @IBOutlet weak var applyThisBadgeView: UIView!
    @IBOutlet weak var spaciousView: UIView!
    @IBOutlet weak var spaciousViewHeight: NSLayoutConstraint!
    
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
    
}
