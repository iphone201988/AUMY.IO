//
//  ViewController.swift
//  AUMY.IO
//
//  Created by iOS Developer on 03/10/25.
//

import UIKit
import DTTextField

class CreateServiceVC: UIViewController {
    
    @IBOutlet weak var serviceNameTF: DTTextField!
    @IBOutlet weak var categoryTF: DTTextField!
    @IBOutlet weak var servicePriceTF: DTTextField!
    @IBOutlet weak var descTV: InterTextView!
    @IBOutlet weak var startTimeTF: DTTextField!
    @IBOutlet weak var endTimeTF: DTTextField!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerCellFromNib(cellID: DayCell.identifier)
        }
    }
    
    var options = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var selectedOptions = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setFloatPlaceholderFont([serviceNameTF, categoryTF, servicePriceTF, startTimeTF, endTimeTF])
        setEditableTextFieldFont([serviceNameTF, categoryTF, servicePriceTF, startTimeTF, endTimeTF])
        customPlaceHolder([serviceNameTF, categoryTF, servicePriceTF, startTimeTF, endTimeTF])
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueTo(_ sender: InterButton) {
        let destVC = AppStoryboards.main.storyboardInstance.instantiateViewController(withIdentifier: "ServiceDetailsVC") as! ServiceDetailsVC
        destVC.event = .createService
        SharedMethods.shared.pushTo(destVC: destVC, isAnimated: true)
    }
}

extension CreateServiceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width)/3.2
        return CGSize(width: width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.identifier, for: indexPath) as! DayCell
        let option = options[indexPath.row]
        cell.dayLbl.text = option
        if selectedOptions.contains(option) {
            cell.selectedIcon.image = UIImage(named: "Rectangle 393")
        } else {
            cell.selectedIcon.image = UIImage(named: "Rectangle 392-1")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        if !selectedOptions.insert(option).inserted {
            selectedOptions.remove(option)
        }
        self.collectionView.reloadData()
    }
}
