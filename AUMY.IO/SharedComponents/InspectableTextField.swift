import UIKit

@IBDesignable
class InspectableTextField: UITextField {

    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            guard let placeholder = placeholder, let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        }
    }
    
    // Optional: Update placeholder color if placeholder text changes programmatically
    override var placeholder: String? {
        didSet {
            if let color = placeholderColor, let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [NSAttributedString.Key.foregroundColor: color]
                )
            }
        }
    }
}
