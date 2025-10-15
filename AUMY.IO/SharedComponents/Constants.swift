import Foundation
import UIKit

struct AppColors {
    static let appColorLight = "appColorLight"
    static let appColor = "appColor"
}

struct CurrentLocation {
    static var latitude = 0.0
    static var longitude = 0.0
}

struct Constants {
    static var role: Roles = .user
    static var deviceType = 2
    static var lblFloatPlaceholderFont = UIFont(name: "Inter-Light", size: 11.0) ?? .systemFont(ofSize: 11.0, weight: .light)
    static var editableTextFieldFont = UIFont(name: "Inter-Regular", size: 16.0)
}
