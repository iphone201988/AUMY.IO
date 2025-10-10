//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class ServiceDetailsVC: UIViewController {
    
    @IBOutlet weak var titleLbl: InterLabel!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var bookServiceView: UIView!
    @IBOutlet weak var deleteOrEditServiceView: UIView!
    @IBOutlet weak var deleteServiceBtn: InterButton!
    @IBOutlet weak var editServiceBtn: InterButton!
    @IBOutlet weak var createServiceBtn: InterButton!
    @IBOutlet weak var availabilityView: UIView!
    @IBOutlet weak var totalReviewView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerCellFromNib(cellID: ServiceReviewCell.identifier)
        }
    }
    
    @IBOutlet weak var daysCollectionView: UICollectionView! {
        didSet {
            daysCollectionView.registerCellFromNib(cellID: DayCell.identifier)
        }
    }
    
    var event: Events = .serviceDetails
    var options = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var selectedOptions = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reviewView.isHidden = true
        noteView.isHidden = true
        bookServiceView.isHidden = true
        deleteOrEditServiceView.isHidden = true
        deleteServiceBtn.isHidden = true
        editServiceBtn.isHidden = true
        createServiceBtn.isHidden = true
        availabilityView.isHidden = true
        totalReviewView.isHidden = false
        
        switch event {
        case .deleteOrEditService:
            titleLbl.text = "Your Services Details"
            noteView.isHidden = false
            deleteOrEditServiceView.isHidden = false
            deleteServiceBtn.isHidden = false
            editServiceBtn.isHidden = false
            
        case .serviceDetails:
            titleLbl.text = "Service Details"
            reviewView.isHidden = false
            bookServiceView.isHidden = false
            
        case .createService:
            titleLbl.text = "Your Services Details"
            deleteOrEditServiceView.isHidden = false
            createServiceBtn.isHidden = false
            availabilityView.isHidden = false
            totalReviewView.isHidden = true
            
        default: break
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookService(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: BookServiceDetailsVC.self, isAnimated: true)
    }
    
    @IBAction func deleteService(_ sender: InterButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let destVC = storyboard.instantiateViewController(withIdentifier: "DeleteServiceVC") as! DeleteServiceVC
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
    }
    
    @IBAction func editService(_ sender: InterButton) {
        SharedMethods.shared.pushToWithoutData(destVC: JobRequestDetailVC.self, isAnimated: true)
    }
    
    @IBAction func createService(_ sender: InterButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let destVC = storyboard.instantiateViewController(withIdentifier: "ServicesCreatedVC") as! ServicesCreatedVC
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension ServiceDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == daysCollectionView {
            return options.count
        } else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == daysCollectionView {
            return .zero
        } else {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == daysCollectionView {
            let width = (daysCollectionView.frame.size.width)/3.2
            return CGSize(width: width, height: 20)
        } else {
            return CGSize(width: 239, height: 113)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == daysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
            let option = options[indexPath.row]
            cell.dayLbl.text = option
            if selectedOptions.contains(option) {
                cell.selectedIcon.image = UIImage(named: "Rectangle 393")
            } else {
                cell.selectedIcon.image = UIImage(named: "Rectangle 392-1")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceReviewCell.identifier, for: indexPath) as! ServiceReviewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == daysCollectionView {
            let option = options[indexPath.row]
            if !selectedOptions.insert(option).inserted {
                selectedOptions.remove(option)
            }
            self.daysCollectionView.reloadData()
        }
    }
}
