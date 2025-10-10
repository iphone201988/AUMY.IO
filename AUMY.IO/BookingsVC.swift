//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class BookingsVC: UIViewController {
    
    @IBOutlet weak var optionsCollectionView: UICollectionView! {
        didSet {
            optionsCollectionView.registerCellFromNib(cellID: OptionCell.identifier)
        }
    }
    
    @IBOutlet weak var ongoingCollectionView: UICollectionView! {
        didSet {
            ongoingCollectionView.registerCellFromNib(cellID: ServiceCell.identifier)
        }
    }
    
    @IBOutlet weak var upcomingCollectionView: UICollectionView! {
        didSet {
            upcomingCollectionView.registerCellFromNib(cellID: ServiceCell.identifier)
        }
    }
    
    @IBOutlet weak var completedCollectionView: UICollectionView! {
        didSet {
            completedCollectionView.registerCellFromNib(cellID: ServiceCell.identifier)
        }
    }
    
    @IBOutlet weak var cancelledCollectionView: UICollectionView! {
        didSet {
            cancelledCollectionView.registerCellFromNib(cellID: ServiceCell.identifier)
        }
    }
    
    var options = ["Ongoing Service", "Upcoming Bookings", "Completed Bookings", "Cancelled Bookings"]
    
    var selectedOption = "Ongoing Service"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showCollectionView()
    }
}

// MARK: Delegates and DataSources
extension BookingsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == optionsCollectionView {
            return options.count
        } else if collectionView == ongoingCollectionView {
            return 1
        } else if collectionView == upcomingCollectionView {
            return 5
        } else if collectionView == completedCollectionView {
            return 5
        } else if collectionView == cancelledCollectionView {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == optionsCollectionView {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == optionsCollectionView {
            return 12
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == optionsCollectionView {
            return .zero
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionsCollectionView {
            let lbl = UILabel(frame: .zero)
            lbl.font = UIFont(name: "Inter-Regular", size: 14.0)
            lbl.text = options[indexPath.row]
            lbl.sizeToFit()
            return CGSize(width: lbl.frame.width + 24, height: 33)
        } else {
            let width = collectionView.frame.width
            if Constants.role == .serviceProvider {
                
                if selectedOption == "Completed Bookings" {
                    return CGSize(width: width, height: 231)
                }
                
                if selectedOption == "Cancelled Bookings" {
                    return CGSize(width: width, height: 221)
                }
                
                return CGSize(width: width, height: 249)
                
            } else {
                return CGSize(width: width, height: 231)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == optionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
            let option = options[indexPath.row]
            cell.optionLbl.text = option
            cell.optionView.borderColor = .white
            if selectedOption == option {
                cell.optionView.backgroundColor = UIColor(named: "374151")
                cell.optionView.borderWidth = 0
            } else {
                cell.optionView.backgroundColor = .clear
                cell.optionView.borderWidth = 1
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCell.identifier, for: indexPath) as! ServiceCell
            
            cell.serviceNameLbl.textColor = .white
            
            cell.viewDetailsView.isHidden = true
            cell.rescheduleView.isHidden = true
            cell.giveReviewView.isHidden = true
            cell.bookAgainView.isHidden = true
            cell.cancelledView.isHidden = true
            cell.locationSpaciousView.isHidden = true
            cell.locationView.isHidden = true
            
            if selectedOption == "Ongoing Service" {
                cell.viewDetailsView.isHidden = false
                cell.serviceStatusView.backgroundColor = UIColor(named: "4FB200")
                cell.serviceStatusLbl.text = "Ongoing Service"
                
            } else if selectedOption == "Upcoming Bookings" {
                cell.viewDetailsView.isHidden = false
                
                if Constants.role == .serviceProvider {
                    cell.rescheduleView.isHidden = true
                } else {
                    cell.rescheduleView.isHidden = false
                }
                
                cell.serviceStatusView.backgroundColor = UIColor(named: "374151")
                cell.serviceStatusLbl.text = "Aug 16, 2025 – 10:00 AM"
                
            } else if selectedOption == "Completed Bookings" {
                
                if Constants.role == .serviceProvider {
                    cell.viewDetailsView.isHidden = false
                } else {
                    cell.giveReviewView.isHidden = false
                    cell.bookAgainView.isHidden = false
                }
                
                cell.serviceStatusView.backgroundColor = UIColor(named: "4FB200")
                cell.serviceStatusLbl.text = "Completed"
                
            } else if selectedOption == "Cancelled Bookings" {
                cell.serviceStatusView.backgroundColor = UIColor(named: "FF4141")
                cell.serviceStatusLbl.text = "Cancelled"
                cell.cancelledView.isHidden = false
            }
            
            if Constants.role == .serviceProvider {
                cell.providerOrCustomerLbl.text = "Customer: John Doe"
                if selectedOption != "Completed Bookings" {
                    cell.locationSpaciousView.isHidden = false
                    cell.locationView.isHidden = false
                }
                
                if selectedOption == "Cancelled Bookings" {
                    cell.locationTitleLbl.text = "Date of Cancellation:"
                    cell.locationLbl.text = " Mon, Aug 21"
                } else {
                    cell.locationTitleLbl.text = "Location:"
                    cell.locationLbl.text = " 2.1 km away"
                }
                
            } else {
                cell.providerOrCustomerLbl.text = "Provider: James"
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == optionsCollectionView {
            selectedOption = options[indexPath.row]
            optionsCollectionView.reloadData()
            showCollectionView()
        } else {
            if selectedOption == "Completed Bookings" {
                SharedMethods.shared.pushToWithoutData(destVC: CompletedBookingDetails.self, isAnimated: true)
            }
            
            if selectedOption == "Upcoming Bookings" {
                if Constants.role == .serviceProvider {
                    let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "UpcomingServiceDetailsVC") as! UpcomingServiceDetailsVC
                    if indexPath.row == 0 {
                        destVC.event = .booked
                    }
                    
                    if indexPath.row == 1 {
                        destVC.event = .onTheWay
                    }
                    
                    if indexPath.row == 2 {
                        destVC.event = .started
                    }
                    
                    if indexPath.row == 3 {
                        destVC.event = .completed
                    }
                    
                    SharedMethods.shared.pushTo(destVC: destVC, isAnimated: true)
                } else {
                    SharedMethods.shared.pushToWithoutData(destVC: BookingDetailsVC.self, isAnimated: true)
                }
            }
            
            if selectedOption == "Cancelled Bookings" {
                SharedMethods.shared.pushToWithoutData(destVC: BookedCancelledVC.self, isAnimated: true)
            }
        }
    }
    
    fileprivate func showCollectionView() {
        ongoingCollectionView.isHidden = true
        upcomingCollectionView.isHidden = true
        completedCollectionView.isHidden = true
        cancelledCollectionView.isHidden = true
        
        if selectedOption == "Ongoing Service" {
            ongoingCollectionView.isHidden = false
            ongoingCollectionView.reloadData()
        } else if selectedOption == "Upcoming Bookings" {
            upcomingCollectionView.isHidden = false
            upcomingCollectionView.reloadData()
        } else if selectedOption == "Completed Bookings" {
            completedCollectionView.isHidden = false
            completedCollectionView.reloadData()
        } else if selectedOption == "Cancelled Bookings" {
            cancelledCollectionView.isHidden = false
            cancelledCollectionView.reloadData()
        }
    }
}
