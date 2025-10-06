//
//  DateCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class DateCell: UICollectionViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dayLbl: InterLabel!
    @IBOutlet weak var dateLbl: InterLabel!
    
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
