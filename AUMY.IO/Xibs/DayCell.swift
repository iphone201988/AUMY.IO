//
//  DayCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 10/10/25.
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var dayLbl: InterLabel!
    
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

}
