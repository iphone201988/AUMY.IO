//
//  TimeCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class TimeCell: UICollectionViewCell {

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLbl: InterLabel!
    
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
