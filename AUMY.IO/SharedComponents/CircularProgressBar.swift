import UIKit

class CircularProgressBar: UIView {
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    var progressColor: UIColor = .systemBlue {
        didSet { progressLayer.strokeColor = progressColor.cgColor }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet { trackLayer.strokeColor = trackColor.cgColor }
    }
    
    var lineWidth: CGFloat = 8 {
        didSet {
            trackLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = lineWidth
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circularPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: (min(bounds.width, bounds.height) - lineWidth) / 2,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        trackLayer.frame = bounds
        progressLayer.frame = bounds
    }
    
    private var centerPoint: CGPoint {
        CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Animate progress smoothly over 2 seconds (or custom duration)
    func setProgress(to value: CGFloat, duration: CFTimeInterval = 2.0) {
        let clampedValue = max(0, min(1, value))
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = progressLayer.presentation()?.strokeEnd ?? 0
        animation.toValue = clampedValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        progressLayer.strokeEnd = clampedValue // For consistency
        progressLayer.add(animation, forKey: "circularProgress")
    }
}
