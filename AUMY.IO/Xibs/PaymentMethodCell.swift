//
//  PaymentMethodCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 08/10/25.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: InterLabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var underlineView: UIView!
    
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
