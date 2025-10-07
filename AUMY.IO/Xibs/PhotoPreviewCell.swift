//
//  PhotoPreviewCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 07/10/25.
//

import UIKit

class PhotoPreviewCell: UICollectionViewCell {
    
    
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
