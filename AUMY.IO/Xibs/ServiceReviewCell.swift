//
//  ServiceReviewCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 08/10/25.
//

import UIKit

class ServiceReviewCell: UICollectionViewCell {

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
