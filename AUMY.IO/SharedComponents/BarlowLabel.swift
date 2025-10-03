import UIKit

@IBDesignable
class BarlowLabel: UILabel {

    @IBInspectable var barlowStyle: String = "Regular" {
        didSet {
            updateFont()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateFont()
    }

    private func updateFont() {
        let fontName = "BarlowCondensed-\(barlowStyle)"
        if let customFont = UIFont(name: fontName, size: self.font.pointSize) {
            self.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Make sure it is added to Info.plist and the app bundle.")
        }
    }
}
