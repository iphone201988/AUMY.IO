import UIKit

@IBDesignable
class BebasLabel: UILabel {

    @IBInspectable var bebasStyle: String = "Regular" {
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
        let fontName = "Bebas-\(bebasStyle)"
        if let customFont = UIFont(name: fontName, size: self.font.pointSize) {
            self.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Make sure it is added to Info.plist and the app bundle.")
        }
    }
}
