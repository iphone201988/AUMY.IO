import UIKit

@IBDesignable
class InterLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateFont()
    }
    
    private func updateFont() {
        let weight = self.font.fontDescriptor.object(forKey: .face) as? String ?? "Regular"
        let mappedStyle = mapWeightToInter(weight)
        let fontName = "Inter-\(mappedStyle)"
        
        if let customFont = UIFont(name: fontName, size: self.font.pointSize) {
            self.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Check Info.plist and bundle.")
        }
    }
    
    /// Maps IB system weights to Inter styles
    private func mapWeightToInter(_ weight: String) -> String {
        switch weight.lowercased() {
        case "ultralight": return "Thin"
        case "thin":       return "ExtraLight"
        case "light":      return "Light"
        case "regular":    return "Regular"
        case "medium":     return "Medium"
        case "semibold":   return "SemiBold"
        case "bold":       return "Bold"
        case "heavy":      return "ExtraBold"
        case "black":      return "Black"
        default:           return "Regular"
        }
    }
}

@IBDesignable
class InterButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateFont()
    }
    
    private func updateFont() {
        guard let titleFont = self.titleLabel?.font else { return }
        
        let weight = titleFont.fontDescriptor.object(forKey: .face) as? String ?? "Regular"
        let mappedStyle = mapWeightToInter(weight)
        let fontName = "Inter-\(mappedStyle)"
        
        if let customFont = UIFont(name: fontName, size: titleFont.pointSize) {
            self.titleLabel?.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Check Info.plist and bundle.")
        }
    }
    
    /// Maps IB system weights to Inter styles
    private func mapWeightToInter(_ weight: String) -> String {
        switch weight.lowercased() {
        case "ultralight": return "Thin"
        case "thin":       return "ExtraLight"
        case "light":      return "Light"
        case "regular":    return "Regular"
        case "medium":     return "Medium"
        case "semibold":   return "SemiBold"
        case "bold":       return "Bold"
        case "heavy":      return "ExtraBold"
        case "black":      return "Black"
        default:           return "Regular"
        }
    }
}

@IBDesignable
class InterTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateFont()
    }
    
    private func updateFont() {
        guard let currentFont = self.font else { return }
        
        let weight = currentFont.fontDescriptor.object(forKey: .face) as? String ?? "Regular"
        let mappedStyle = mapWeightToInter(weight)
        let fontName = "Inter-\(mappedStyle)"
        
        if let customFont = UIFont(name: fontName, size: currentFont.pointSize) {
            self.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Check Info.plist and bundle.")
        }
    }
    
    /// Maps IB system weights to Inter styles
    private func mapWeightToInter(_ weight: String) -> String {
        switch weight.lowercased() {
        case "ultralight": return "Thin"
        case "thin":       return "ExtraLight"
        case "light":      return "Light"
        case "regular":    return "Regular"
        case "medium":     return "Medium"
        case "semibold":   return "SemiBold"
        case "bold":       return "Bold"
        case "heavy":      return "ExtraBold"
        case "black":      return "Black"
        default:           return "Regular"
        }
    }
}

@IBDesignable
class InterTextView: UITextView {
    
    // Called when loaded from storyboard/xib
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }
    
    // Called when rendering inside Interface Builder
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateFont()
    }
    
    private func updateFont() {
        guard let currentFont = self.font else { return }
        
        let weight = currentFont.fontDescriptor.object(forKey: .face) as? String ?? "Regular"
        let mappedStyle = mapWeightToInter(weight)
        let fontName = "Inter-\(mappedStyle)"
        
        if let customFont = UIFont(name: fontName, size: currentFont.pointSize) {
            self.font = customFont
        } else {
            LogHandler.debugLog("⚠️ Font '\(fontName)' not found. Make sure it’s added to your project and Info.plist.")
        }
    }
    
    /// Maps IB system weights to Inter styles
    private func mapWeightToInter(_ weight: String) -> String {
        switch weight.lowercased() {
        case "ultralight": return "Thin"
        case "thin":       return "ExtraLight"
        case "light":      return "Light"
        case "regular":    return "Regular"
        case "medium":     return "Medium"
        case "semibold":   return "SemiBold"
        case "bold":       return "Bold"
        case "heavy":      return "ExtraBold"
        case "black":      return "Black"
        default:           return "Regular"
        }
    }
}
