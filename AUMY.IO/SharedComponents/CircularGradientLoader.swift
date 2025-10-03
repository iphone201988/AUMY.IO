import UIKit

class CircularGradientLoader1: UIView {
    
    private let shapeLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }
    
    private func setupLoader() {
        let lineWidth: CGFloat = 6
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Arc path
        let circularPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0.85
        
        // Gradient layer: transparent → white
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor, // transparent start
            UIColor.white.withAlphaComponent(1).cgColor  // opaque end
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "rotation")
        
        // Stop after 10 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.stopAnimating()
        }
    }
    
    func stopAnimating() {
        // Optional: fade out effect
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.layer.removeAnimation(forKey: "rotation")
            self.removeFromSuperview()
        }
    }
}
