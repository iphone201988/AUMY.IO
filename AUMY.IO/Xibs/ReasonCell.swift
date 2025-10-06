//
//  ReasonCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class ReasonCell: UITableViewCell {

    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var reasonLbl: InterLabel!
    @IBOutlet weak var spaciousTopView: UIView!
    @IBOutlet weak var otherReasonView: UIView!
    
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
