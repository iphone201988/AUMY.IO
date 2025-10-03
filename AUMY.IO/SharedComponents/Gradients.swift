import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.purple
    @IBInspectable var bottomColor: UIColor = UIColor.blue
    private var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.removeFromSuperlayer()
        let layer = CAGradientLayer()
        layer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5) // left center
        layer.endPoint = CGPoint(x: 1, y: 0.5)   // right center
        layer.frame = self.bounds
        layer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(layer, at: 0)
        gradientLayer = layer
    }
}

@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var topColor: UIColor = UIColor.purple
    @IBInspectable var bottomColor: UIColor = UIColor.blue
    private var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.removeFromSuperlayer()
        let layer = CAGradientLayer()
        layer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5) // left center
        layer.endPoint = CGPoint(x: 1, y: 0.5)   // right center
        layer.frame = bounds
        layer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(layer, at: 0)
        gradientLayer = layer
    }
}
