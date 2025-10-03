import UIKit

enum AppStoryboards: String {
    case main = "Main"
    case menus = "Menus"
    
    var storyboardInstance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func controller<T: UIViewController>(_ type: T.Type) -> T? {
        let identifier = String(describing: type)
        return storyboardInstance.instantiateViewController(withIdentifier: identifier) as? T
    }
}

enum ViewControllers {
    case homeVC
    case mapVC
    case selectLocationVC
    case chooseVehicleVC
    case pickupDetailsVC
    case serviceDetailsVC
    case cancelServiceVC
    case serviceCanclledVC
    case messageDriverVC
}

enum Role {
    case user
    case driver
    
    var type: Int {
        switch self {
        case .user: return 1
        case .driver: return 1
        }
    }
}

enum Events {
    case signup
    case signin
    case forgotPassword
    case changePassword
    case logout
    case updateProfile
    case updatePassword
}
