//
//  ServiceCell.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ServiceCell: UICollectionViewCell {
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var rescheduleView: UIView!
    @IBOutlet weak var viewDetailsView: UIView!
    @IBOutlet weak var giveReviewView: UIView!
    @IBOutlet weak var bookAgainView: UIView!
    @IBOutlet weak var serviceStatusView: UIView!
    @IBOutlet weak var serviceStatusLbl: InterLabel!
    @IBOutlet weak var serviceNameLbl: InterLabel!
    @IBOutlet weak var cancelledView: UIView!
    
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
