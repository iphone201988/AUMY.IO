//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//


import UIKit

class HomeVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var searchSpaciousView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var emptySpaciousView: UIView!
    @IBOutlet weak var createServiceBtn: InterButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            switch Constants.role {
            case .serviceProvider:
                sections = ["Ongoing Service", "Your Upcoming Service", "Job Request"]
                
            case .user:
                sections = ["Ongoing Service",
                            "Upcoming Booking",
                            "AI-Powered Task Recommendations",
                            "Popular Services"]
            }
            
            var configs: [SectionLayoutConfig] = []
            
            switch Constants.role {
            case .serviceProvider:
                configs = [
                    SectionLayoutConfig(itemWidth: collectionView.frame.width - 36, itemHeight: 249),
                    SectionLayoutConfig(itemWidth: 208, itemHeight: 220, interGroupSpacing: 16),
                    SectionLayoutConfig(itemWidth: 208, itemHeight: 202, interGroupSpacing: 16),
                ]
                
            case .user:
                configs = [
                    SectionLayoutConfig(itemWidth: collectionView.frame.width - 36, itemHeight: 231),
                    SectionLayoutConfig(itemWidth: 208, itemHeight: 202, interGroupSpacing: 16),
                    SectionLayoutConfig(itemWidth: 295, itemHeight: 44, interGroupSpacing: 16),
                    SectionLayoutConfig(itemWidth: 165, itemHeight: 110, interGroupSpacing: 12)
                ]
            }
            
            collectionView.setCollectionViewLayout(createLayout(configs: configs), animated: false)
            
            collectionView.registerCellFromNib(cellID: ServiceCell.identifier)
            collectionView.registerCellFromNib(cellID: TaskCell.identifier)
            collectionView.registerCellFromNib(cellID: PopularServiceCell.identifier)
            
            // Correct registration for supplementary view (header)
            collectionView.register(
                HeaderCell.nib,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderCell.identifier
            )
        }
    }
    
    // MARK: Variables
    fileprivate var sections = [String]()
    
    // MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        switch Constants.role {
        case .serviceProvider:
            searchSpaciousView.isHidden = true
            searchView.isHidden = true
            createServiceBtn.isHidden = false
            emptySpaciousView.isHidden = false
            
        case .user:
            searchSpaciousView.isHidden = false
            searchView.isHidden = false
            createServiceBtn.isHidden = true
            emptySpaciousView.isHidden = true
        }
    }
    
    // MARK: IB Actions
    @IBAction func search(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: SearchVC.self, isAnimated: true)
    }
    
    @IBAction func createService(_ sender: InterButton) {
    }
    
    // MARK: Shared Methods
}

// MARK: Delegates and DataSources
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sections.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return .leastNonzeroMagnitude
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCell.identifier, for: indexPath) as! ServiceCell
            
            cell.locationSpaciousView.isHidden = true
            cell.locationView.isHidden = true
            cell.providerOrCustomerLbl.text = "Provider: James"
            
            if Constants.role == .serviceProvider {
                cell.locationSpaciousView.isHidden = false
                cell.locationView.isHidden = false
                cell.providerOrCustomerLbl.text = "Customer: John Doe"
            }
            
            if indexPath.section == 0 {
                cell.imgHeight.constant = 160
                cell.rescheduleView.isHidden = true
                cell.serviceStatusView.backgroundColor = UIColor(named: "4FB200")
                if indexPath.row == 0 {
                    cell.serviceStatusLbl.text = "Ongoing Service"
                } else {
                    cell.serviceStatusLbl.text = "Service Completed"
                }
                cell.serviceNameLbl.text = "House Cleaning Service"
                
            } else if indexPath.section == 1 {
                cell.imgHeight.constant = 131
                cell.serviceStatusView.backgroundColor = UIColor(named: "374151")
                cell.serviceStatusLbl.text = "Aug 16, 2025 – 10:00 AM"
                cell.serviceNameLbl.text = "Cleaning"
                
                if Constants.role == .serviceProvider {
                    cell.rescheduleView.isHidden = true
                } else {
                    cell.rescheduleView.isHidden = false
                }
            }
            return cell
        } else if indexPath.section == 2 {
            switch Constants.role {
            case .serviceProvider:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCell.identifier, for: indexPath) as! ServiceCell
                
                cell.imgHeight.constant = 131
                cell.rescheduleView.isHidden = true
                cell.serviceStatusView.backgroundColor = UIColor(named: "374151")
                //cell.serviceStatusLbl.text = "Aug 16, 2025 – 10:00 AM"
                cell.serviceStatusView.isHidden = true
                cell.serviceNameLbl.text = "Cleaning"
                cell.providerOrCustomerLbl.text = "Customer: John Doe"
                
                return cell
                
            case .user:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
                return cell
            }
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularServiceCell.identifier, for: indexPath) as! PopularServiceCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCell.identifier,
                for: indexPath) as! HeaderCell
            header.optionLbl.text = sections[indexPath.section]
            return header
        }
        fatalError("Unsupported supplementary view kind")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "OngoingServiceDetailsVC") as! OngoingServiceDetailsVC
            if indexPath.row == 0 {
                destVC.isCompleted = false
            } else {
                destVC.isCompleted = true
            }
            SharedMethods.shared.pushTo(destVC: destVC, isAnimated: true)
        }
    }
}
