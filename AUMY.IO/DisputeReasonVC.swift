//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit

class DisputeReasonVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: ReasonCell.identifier)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var photosCollectionView: UICollectionView! {
        didSet {
            photosCollectionView.registerCellFromNib(cellID: PhotoPreviewCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        let storyboard = AppStoryboards.main.storyboardInstance
        let destVC = storyboard.instantiateViewController(withIdentifier: "DisputeSuccessfullyPopupVC") as! DisputeSuccessfullyPopupVC
        destVC.servicesEventDelegate = self
        SharedMethods.shared.presentVC(destVC: destVC, modalPresentationStyle: .overFullScreen, isAnimated: true)
    }
    
}

extension DisputeReasonVC: ServicesEvents {
    func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Delegates and DataSources
extension DisputeReasonVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReasonCell.identifier, for: indexPath) as! ReasonCell
        cell.spaciousTopView.isHidden = true
        cell.otherReasonView.isHidden = true
        cell.selectedIcon.image = UIImage(named: "Rectangle 392")
        if indexPath.row == 5 {
            cell.spaciousTopView.isHidden = false
            cell.otherReasonView.isHidden = false
            cell.selectedIcon.image = UIImage(named: "Group 60515")
        }
        return cell
    }
}

// MARK: Delegates and DataSources
extension DisputeReasonVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPreviewCell.identifier, for: indexPath) as! PhotoPreviewCell
        return cell
    }
}
