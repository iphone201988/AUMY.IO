import Foundation
import UIKit

// MARK: Dropdown Manager
class DropdownManager: UITextField {
    
    // MARK: Shared Instance
    static let shared = DropdownManager(frame: .zero, parentController: nil)
    
    // MARK: Closures
    fileprivate var didSelectCompletion: (String, [DropdownItem], IndexPath) -> () = {selectedItem, dropDownItems, index  in }
    
    // MARK: Shared View's Components
    fileprivate var tableView: UITableView?
    fileprivate var parentController: UIViewController?
    fileprivate var shadowView: UIView!
    
    // MARK: View's Associated Properties
    var rowHeight: CGFloat = 30
    var rowBackgroundColor: UIColor = .white
    var rowTextLabelColor: UIColor = .white
    var selectedRowColor: UIColor = .cyan
    
    // MARK: Variables
    var dropDownItems = [DropdownItem]()
    var listHeight: CGFloat = 0.0
    var visibleParentVC: UIViewController?
    
    // MARK: init()
    init(frame: CGRect, parentController: UIViewController?) {
        super.init(frame: frame)
        self.parentController = parentController
        self.visibleParentVC = parentController
        setupParentController()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupParentController()
        setupTableView()
    }
    
    // MARK: Setup Parent Controller
    private func setupParentController() {
        if parentController == nil {
            parentController = visibleParentVC
        }
    }
    
    // MARK: Setup Table View
    private func setupTableView() {
        tableView = UITableView(frame: bounds, style: .plain)
        tableView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView?.registerCellFromNib(cellID: "HeaderView")
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.alpha = 0
        tableView?.separatorStyle = .none
        tableView?.layer.cornerRadius = 3
        tableView?.backgroundColor = rowBackgroundColor
        tableView?.rowHeight = rowHeight
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0
        }
        
        if let tableView {
            addSubview(tableView)
        }
    }
    
    // MARK: Shared Methods
    func showDropdown() {
        if tableView == nil {
            tableView = UITableView()
            tableView?.dataSource = self
            tableView?.delegate = self
        }
        guard
            let tableView = tableView,
            let parentController = parentController
        else { return }
        
        tableView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: .leastNormalMagnitude)
        tableView.backgroundColor = .label
        tableView.reloadData()
        
        if shadowView == nil {
            shadowView = UIView(frame: tableView.frame)
        }
        
        if let shadowView = shadowView {
            parentController.view.addSubview(shadowView)
            parentController.view.addSubview(tableView)
            
            self.isSelected = true
            
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: {
                tableView.alpha = 1
                // tableView.frame.size.height = self.listHeight
                self.resizeView()
                shadowView.frame = tableView.frame
            }, completion: { _ in
                self.layoutIfNeeded()
            })
        } else {
            LogHandler.debugLog("no shadow view")
        }
    }
    
    func hideDropdown(withDuration: TimeInterval? = 1.0, delay: TimeInterval? = 0.4) {
        guard
            let tableView = tableView,
            let shadowView = shadowView
        else { return }
        
        UIView.animate(withDuration: withDuration ?? 1.0,
                       delay: delay ?? 0.4,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: {
            tableView.frame.size.height = 0
            shadowView.alpha = 0
            shadowView.frame = tableView.frame
        }, completion: { [weak self] (didFinish) in
            tableView.removeFromSuperview()
            shadowView.removeFromSuperview()
            self?.isSelected = false
        })
    }
    
    //MARK: Observers Method
    @objc func reloadWorkoutsListDropdownItems(_ notify: NSNotification) {
        tableView?.reloadData()
        resizeView()
    }
    
    fileprivate func resizeView() {
        // Fetch height according to Tableview content
        let heightAccordingToContent = tableView?.contentSize.height ?? 0
        let screenHeight = UIScreen.main.bounds.height
        let requireHeight = screenHeight * 0.75
        if heightAccordingToContent > requireHeight {
            tableView?.frame.size.height = requireHeight
        } else {
            tableView?.frame.size.height = heightAccordingToContent
        }
    }
    
    //MARK: Closures Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ dropDownItems: [DropdownItem], _ index: IndexPath) -> ()) {
        didSelectCompletion = completion
    }
}

// MARK: TableView's DataSource and Delegate Methods
extension DropdownManager: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dropDownItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dropDownItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let section = indexPath.section
        let row = indexPath.row
        if section < dropDownItems.count {
            if row < dropDownItems[section].items.count {
                let rowItem = dropDownItems[section].items[row]
                cell.textLabel?.text = rowItem.title
                cell.accessoryType = rowItem.isSelected ? .checkmark : .none
                cell.selectionStyle = .none
                cell.textLabel?.font = self.font
                cell.textLabel?.textAlignment = self.textAlignment
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.textColor = rowTextLabelColor
                cell.backgroundColor = rowItem.isSelected ? .lightGray : .label
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section < dropDownItems.count {
            if row < dropDownItems[section].items.count {
                let rowItem = dropDownItems[section].items[row]
                resetIsSelectedStatusToFalse(indexPath: indexPath)
                updateIsSelectedStatus(indexPath: indexPath)
                self.tableView?.reloadData()
                didSelectCompletion(rowItem.title, dropDownItems, indexPath)
                hideDropdown()
            }
        }
    }
    
    func resetIsSelectedStatusToFalse(indexPath: IndexPath) {
        let sectionRowCount = dropDownItems[indexPath.section].items.count
        for row in 0..<sectionRowCount {
            dropDownItems[indexPath.section].items[row].isSelected = false
        }
    }
    
    func updateIsSelectedStatus(indexPath: IndexPath) {
        dropDownItems[indexPath.section].items[indexPath.row].isSelected = true
    }
}

// MARK: Dropdown Model
struct DropdownItem {
    var header: String = ""
    var items: [Item] = []
}

struct Item {
    var title: String = ""
    var isSelected: Bool = false
}
