//
//  RescheduleBookingVC.swift
//  AUMY.IO
//
//  Created by iOS Developer on 06/10/25.
//

import UIKit

class RescheduleBookingVC: UIViewController {
    
    @IBOutlet weak var dateCollectionView: UICollectionView! {
        didSet {
            generateDates()
            dateCollectionView.registerCellFromNib(cellID: DateCell.identifier)
        }
    }
    
    @IBOutlet weak var timeCollectionView: UICollectionView! {
        didSet {
            generateTimeSlots()
            timeCollectionView.registerCellFromNib(cellID: TimeCell.identifier)
        }
    }
    
    // MARK: - Properties
    private var dates: [Date] = []
    private var timeSlots: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Generate Dates (Today → +29 Days)
    private func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        // Generate dates for 30 days starting today
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
    }
    
    // MARK: - Generate Time Slots (Next Full Hour → 11:00 PM)
    private func generateTimeSlots() {
        let calendar = Calendar.current
        let now = Date()
        
        // Round up to the next full hour
        var nextHour = calendar.date(bySetting: .minute, value: 0, of: now)!
        nextHour = calendar.date(byAdding: .hour, value: 1, to: nextHour)!
        
        // End time: 11:00 PM today
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 23
        components.minute = 0
        guard let endOfDay = calendar.date(from: components) else { return }
        
        // Add all 1-hour intervals until 11:00 PM
        var slot = nextHour
        while slot <= endOfDay {
            timeSlots.append(slot)
            slot = calendar.date(byAdding: .hour, value: 1, to: slot)!
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func close(_ sender: InterButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        SharedMethods.shared.pushToWithoutData(destVC: RescheduledBookingVC.self, isAnimated: true)
    }
}

// MARK: Delegates and DataSources
extension RescheduleBookingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return dates.count
        } else {
            return timeSlots.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 55, height: 55)
        } else {
            return CGSize(width: 88, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
            let date = dates[indexPath.item]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d" // just the date (e.g., 6)
            cell.dateLbl.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "EEE" // day abbreviation (e.g., Mon, Tue)
            cell.dayLbl.text = dateFormatter.string(from: date)
            cell.dateView.borderWidth = 1
            cell.dateView.backgroundColor = UIColor(named: "454C57_40")
            cell.dayLbl.textColor = .white
            cell.dateLbl.textColor = .white
            if indexPath.item == 1 {
                cell.dateView.borderWidth = 0
                cell.dateView.backgroundColor = UIColor(named: "374151")
            } else if indexPath.item == 3 {
                cell.dateView.backgroundColor = UIColor(named: "AAAAAA_40")
                cell.dayLbl.textColor = UIColor(named: "FFFFFF_30")
                cell.dateLbl.textColor = UIColor(named: "FFFFFF_30")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCell.identifier, for: indexPath) as! TimeCell
            let time = timeSlots[indexPath.item]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            cell.timeLbl.text = dateFormatter.string(from: time)
            cell.timeView.borderWidth = 1
            cell.timeView.backgroundColor = UIColor(named: "454C57_40")
            cell.timeLbl.textColor = .white
            if indexPath.item == 3 {
                cell.timeView.borderWidth = 0
                cell.timeView.backgroundColor = UIColor(named: "374151")
            } else if indexPath.item == 0 {
                cell.timeView.backgroundColor = UIColor(named: "AAAAAA_40")
                cell.timeLbl.textColor = UIColor(named: "FFFFFF_30")
            }
            return cell
        }
    }
}
