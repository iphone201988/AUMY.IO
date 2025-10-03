import UIKit

// MARK: - Custom Transition
class ThumbnailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.5
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        if isPresenting {
            guard let toVC = transitionContext.viewController(forKey: .to) else { return }
            
            toVC.view.alpha = 0
            container.addSubview(toVC.view)
            
            UIView.animate(withDuration: duration, animations: {
                toVC.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
            
        } else {
            guard
                let fromVC = transitionContext.viewController(forKey: .from),
                let toVC = transitionContext.viewController(forKey: .to)
            else { return }
            
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            toVC.view.alpha = 0
            
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.alpha = 0
                toVC.view.alpha = 1
            }, completion: { _ in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}

class CardTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    var sourceFrame: CGRect = .zero
    weak var sourceView: UIView?
    weak var sourceCollectionView: UICollectionView?
    weak var parentView: UIView?
    var sourceIndexPath: IndexPath?
    var transitionDuration = 1.0
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting, sourceFrame: sourceFrame)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CardPresentationAnimator(isPresenting: true, sourceFrame: sourceFrame, sourceView: sourceView, sourceCollectionView: sourceCollectionView, sourceIndexPath: sourceIndexPath, parentView: parentView, transitionDuration: transitionDuration)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentationAnimator(isPresenting: false, sourceFrame: sourceFrame, sourceView: sourceView, sourceCollectionView: sourceCollectionView, sourceIndexPath: sourceIndexPath, parentView: parentView, transitionDuration: transitionDuration)
    }
}

// MARK: - Presentation Controller
class CardPresentationController: UIPresentationController {
    
    private let sourceFrame: CGRect
    private let dimmingView = UIView()
    
    init(presentedViewController: UIViewController, presenting: UIViewController?, sourceFrame: CGRect) {
        self.sourceFrame = sourceFrame
        super.init(presentedViewController: presentedViewController, presenting: presenting)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView?.bounds ?? .zero
    }
}

// MARK: - Animation Controller
class CardPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresenting: Bool
    private let sourceFrame: CGRect
    private weak var sourceView: UIView?
    private weak var sourceCollectionView: UICollectionView?
    private weak var parentView: UIView?
    private var sourceIndexPath: IndexPath?
    private var transitionDuration = 1.0
    
    init(isPresenting: Bool, sourceFrame: CGRect, sourceView: UIView?, sourceCollectionView: UICollectionView? = nil, sourceIndexPath: IndexPath? = nil, parentView: UIView? = nil, transitionDuration: Double = 1.0) {
        self.isPresenting = isPresenting
        self.sourceFrame = sourceFrame
        self.sourceView = sourceView
        self.sourceCollectionView = sourceCollectionView
        self.sourceIndexPath = sourceIndexPath
        self.parentView = parentView
        self.transitionDuration = transitionDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentation(using: transitionContext)
        } else {
            animateDismissal(using: transitionContext)
        }
    }
    
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let sourceView = sourceView,
              let fromSnapshot = sourceView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let initialFrame = containerView.convert(sourceFrame, from: nil)
        
        // Setup snapshot
        fromSnapshot.frame = initialFrame
        fromSnapshot.layer.cornerRadius = 12
        fromSnapshot.clipsToBounds = true
        
        // Add blur on top of snapshot (so card becomes blurred)
        let blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = fromSnapshot.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fromSnapshot.addSubview(blurEffectView)
        
        // Setup toVC
        toVC.view.frame = finalFrame
        toVC.view.alpha = 0
        toVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        
        sourceView.isHidden = true
        
        // Add views in order
        containerView.addSubview(toVC.view)         // Behind
        containerView.addSubview(fromSnapshot)      // On top
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic]) {
            
            // 🔵 Add blur effect inside the expanding snapshot (card itself becomes blur)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                blurEffectView.effect = UIBlurEffect(style: .dark)
            }
            
            // 🔴 Expand and fade out the card
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                fromSnapshot.frame = finalFrame
                fromSnapshot.layer.cornerRadius = 0
                fromSnapshot.alpha = 0.0
            }
            
            // 🟢 Simultaneously fade and scale in the destination view
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                toVC.view.alpha = 1.0
                toVC.view.transform = .identity
            }
            
        } completion: { _ in
            fromSnapshot.removeFromSuperview()
            sourceView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        if transitionType == .coverPage {
            creatorCoverPageTouchTransition(transitionContext)
        } else {
            movieCardTouchTransition(transitionContext)
        }
    }
    
    fileprivate func creatorCoverPageTouchTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let sourceView = sourceView else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        var targetFrame = sourceFrame
        
        if let collectionView = sourceCollectionView,
           let indexPath = sourceIndexPath,
           let cell = collectionView.cellForItem(at: indexPath) {
            let cellFrameInWindow = cell.convert(cell.bounds, to: nil)
            targetFrame = containerView.convert(cellFrameInWindow, from: nil)
        }
        
        // Snapshot of the presented VC
        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        snapshot.frame = fromVC.view.frame
        snapshot.layer.cornerRadius = 12
        snapshot.clipsToBounds = true
        
        // Blur view
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = snapshot.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.0
        snapshot.addSubview(blurView)
        
        containerView.addSubview(snapshot)
        
        sourceView.alpha = 0
        sourceView.isHidden = false
        fromVC.view.isHidden = true
        
        let totalDuration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.calculationModeCubic]) {
            
            // Blur fade-in starts immediately (0% to 20% of duration)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                blurView.alpha = 1.0
            }
            
            // Slight scale down starts immediately (0% to 30%)
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                snapshot.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
            }
            
            // Main shrink and fade (start after 20%, run for 80%)
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                snapshot.transform = .identity
                snapshot.frame = targetFrame
                snapshot.alpha = 0.0
                self.sourceView?.alpha = 1.0
            }
            
        } completion: { _ in
            snapshot.removeFromSuperview()
            self.sourceView?.alpha = 1.0
            self.sourceView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    fileprivate func movieCardTouchTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        var dismissalFrame = sourceFrame
        
        if let collectionView = sourceCollectionView,
           let indexPath = sourceIndexPath,
           let currentCell = collectionView.cellForItem(at: indexPath) {
            let currentCellFrameInWindow = currentCell.convert(currentCell.bounds, to: nil)
            dismissalFrame = containerView.convert(currentCellFrameInWindow, from: nil)
        }
        
        // Snapshot of full screen
        guard let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        snapshotView.frame = fromViewController.view.frame
        snapshotView.layer.cornerRadius = 12
        snapshotView.clipsToBounds = true
        containerView.addSubview(snapshotView)
        
        // Prepare the original thumbnail to fade in
        if let thumbnail = sourceView {
            thumbnail.alpha = 0.0
            thumbnail.isHidden = false
        }
        
        fromViewController.view.isHidden = true
        
        // Animate shrink & blur (snapshotView) + reveal (thumbnail)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.3,
                       options: [.curveEaseInOut]) {
            
            snapshotView.frame = dismissalFrame
            snapshotView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            snapshotView.alpha = 0.0
            self.sourceView?.alpha = 1.0 // thumbnail fades in smoothly
        } completion: { _ in
            snapshotView.removeFromSuperview()
            self.sourceView?.alpha = 1.0
            self.sourceView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

enum Transitions {
    case coverPage
    case movieCard
}

var transitionType: Transitions = .coverPage

// Transitions
/*
 private func animatePresentationFA01(using transitionContext: UIViewControllerContextTransitioning) {
 guard let toVC = transitionContext.viewController(forKey: .to),
 let sourceView = sourceView,
 let fromSnapshot = sourceView.snapshotView(afterScreenUpdates: true) else {
 transitionContext.completeTransition(false)
 return
 }
 
 let containerView = transitionContext.containerView
 let finalFrame = transitionContext.finalFrame(for: toVC)
 let initialFrame = containerView.convert(sourceFrame, from: nil)
 
 // Setup snapshot
 fromSnapshot.frame = initialFrame
 fromSnapshot.layer.cornerRadius = 12
 fromSnapshot.clipsToBounds = true
 
 // Blur inside card
 let blurEffectView = UIVisualEffectView(effect: nil)
 blurEffectView.frame = fromSnapshot.bounds
 blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 fromSnapshot.addSubview(blurEffectView)
 
 // Setup toVC view
 toVC.view.frame = finalFrame
 toVC.view.alpha = 0.0
 toVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
 
 sourceView.isHidden = true
 
 containerView.addSubview(toVC.view)        // Behind
 containerView.addSubview(fromSnapshot)     // On top
 
 let duration = transitionDuration(using: transitionContext)
 
 UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic]) {
 
 // 🔄 0% → 100%: card expands, fades out & blur intensifies
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
 fromSnapshot.frame = finalFrame
 fromSnapshot.alpha = 0.0
 fromSnapshot.layer.cornerRadius = 0
 blurEffectView.effect = UIBlurEffect(style: .dark)
 }
 
 // 🔄 0% → 100%: toVC fades in + scales in at exact same time
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
 toVC.view.alpha = 1.0
 toVC.view.transform = .identity
 }
 
 } completion: { _ in
 fromSnapshot.removeFromSuperview()
 sourceView.isHidden = false
 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
 }
 }
 
 private func animatePresentationFA0(using transitionContext: UIViewControllerContextTransitioning) {
 guard let toVC = transitionContext.viewController(forKey: .to),
 let sourceView = sourceView,
 let fromSnapshot = sourceView.snapshotView(afterScreenUpdates: true) else {
 transitionContext.completeTransition(false)
 return
 }
 
 let containerView = transitionContext.containerView
 let finalFrame = transitionContext.finalFrame(for: toVC)
 let initialFrame = containerView.convert(sourceFrame, from: nil)
 
 // Setup snapshot (card)
 fromSnapshot.frame = initialFrame
 fromSnapshot.layer.cornerRadius = 12
 fromSnapshot.clipsToBounds = true
 
 // Blur inside card
 let cardBlurView = UIVisualEffectView(effect: nil)
 cardBlurView.frame = fromSnapshot.bounds
 cardBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 fromSnapshot.addSubview(cardBlurView)
 
 // Setup destination view
 toVC.view.frame = finalFrame
 toVC.view.alpha = 1.0   // make alpha 1 for better blending
 toVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
 
 // Add blur on top of toVC
 let fadeBlur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
 fadeBlur.frame = toVC.view.bounds
 fadeBlur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 toVC.view.addSubview(fadeBlur)
 
 sourceView.isHidden = true
 
 containerView.addSubview(toVC.view)        // Behind
 containerView.addSubview(fromSnapshot)     // On top
 
 let duration = transitionDuration(using: transitionContext)
 
 UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic]) {
 
 // 🔸 Card expands & fades out quickly in first 75%
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75) {
 fromSnapshot.frame = finalFrame
 fromSnapshot.alpha = 0.0
 fromSnapshot.layer.cornerRadius = 0
 cardBlurView.effect = UIBlurEffect(style: .dark)
 }
 
 // 🔹 toVC scales in (whole time)
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
 toVC.view.transform = .identity
 }
 
 // 🔹 toVC blur fades out starting from 60% to 100%
 UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
 fadeBlur.effect = nil
 }
 
 } completion: { _ in
 fromSnapshot.removeFromSuperview()
 fadeBlur.removeFromSuperview()
 sourceView.isHidden = false
 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
 }
 }
 
 private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
 guard let toVC = transitionContext.viewController(forKey: .to),
 let sourceView = sourceView,
 let fromSnapshot = sourceView.snapshotView(afterScreenUpdates: true) else {
 transitionContext.completeTransition(false)
 return
 }
 
 let containerView = transitionContext.containerView
 let finalFrame = transitionContext.finalFrame(for: toVC)
 let initialFrame = containerView.convert(sourceFrame, from: nil)
 
 // Setup snapshot
 fromSnapshot.frame = initialFrame
 fromSnapshot.layer.cornerRadius = 12
 fromSnapshot.clipsToBounds = true
 
 // Card blur
 let cardBlurView = UIVisualEffectView(effect: nil)
 cardBlurView.frame = fromSnapshot.bounds
 cardBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 fromSnapshot.addSubview(cardBlurView)
 
 // Setup toVC
 toVC.view.frame = finalFrame
 toVC.view.alpha = 0
 toVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
 
 // Add light blur over toVC.view (fades later)
 let toVCBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
 toVCBlurView.frame = toVC.view.bounds
 toVCBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 toVC.view.addSubview(toVCBlurView)
 
 sourceView.isHidden = true
 containerView.addSubview(toVC.view)
 containerView.addSubview(fromSnapshot)
 
 let duration = transitionDuration(using: transitionContext)
 
 UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic]) {
 
 // Card: expand, blur and fade (0% → 70%)
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
 fromSnapshot.frame = finalFrame
 fromSnapshot.alpha = 0
 fromSnapshot.layer.cornerRadius = 0
 cardBlurView.effect = UIBlurEffect(style: .light)
 }
 
 // toVC: fade in and scale (0% → 100%)
 UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
 toVC.view.alpha = 1.0
 toVC.view.transform = .identity
 }
 
 // toVC blur fade out (30% → 60%)
 UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
 toVCBlurView.effect = nil
 }
 
 } completion: { _ in
 fromSnapshot.removeFromSuperview()
 toVCBlurView.removeFromSuperview()
 sourceView.isHidden = false
 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
 }
 }
 
 private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
 guard let fromViewController = transitionContext.viewController(forKey: .from) else {
 transitionContext.completeTransition(false)
 return
 }
 
 let containerView = transitionContext.containerView
 var dismissalFrame = sourceFrame
 
 if let collectionView = sourceCollectionView,
 let indexPath = sourceIndexPath,
 let currentCell = collectionView.cellForItem(at: indexPath) {
 
 let currentCellFrameInWindow = currentCell.convert(currentCell.bounds, to: nil)
 dismissalFrame = containerView.convert(currentCellFrameInWindow, from: nil)
 }
 
 
 guard let image = UIImage(named: "Rectangle 4") else {
 transitionContext.completeTransition(false)
 return
 }
 
 let imageView = UIImageView(image: image)
 imageView.frame = fromViewController.view.frame
 imageView.contentMode = .scaleAspectFill
 imageView.clipsToBounds = true
 imageView.layer.cornerRadius = 0
 
 containerView.addSubview(imageView)
 
 // Animate the main screen fade out (not immediately hidden)
 UIView.animate(withDuration: 0.2) { // 0.2
 fromViewController.view.alpha = 0.0
 }
 
 // 🔥 Animate the thumbnail shrinking into its original spot
 //        UIView.animate(withDuration: transitionDuration(using: transitionContext),
 //                       delay: 0,
 //                       usingSpringWithDamping: 0.85,
 //                       initialSpringVelocity: 0.3,
 //                       options: [.curveEaseInOut]) {
 //
 //            imageView.frame = dismissalFrame
 //            imageView.layer.cornerRadius = 12
 //            imageView.alpha = 0.0
 //            imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
 //
 //        } completion: { _ in
 //            fromViewController.view.isHidden = true
 //            imageView.removeFromSuperview()
 //            self.sourceView?.isHidden = false
 //            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
 //        }
 
 
 // Animate the thumbnail shrinking into its original spot
 UIView.animate(withDuration: transitionDuration(using: transitionContext),
 delay: 0,
 usingSpringWithDamping: 0.85,
 initialSpringVelocity: 0.3,
 options: [.curveEaseInOut]) {
 
 imageView.frame = dismissalFrame
 imageView.layer.cornerRadius = 12
 imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
 
 } completion: { _ in
 fromViewController.view.isHidden = true
 imageView.removeFromSuperview()
 self.sourceView?.isHidden = false
 transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
 }
 
 // Fade out alpha separately for smoother effect
 UIView.animate(withDuration: 0.2,
 delay: 0.15, // small delay for blend
 options: [.curveEaseIn]) {
 imageView.alpha = 0.0
 }
 
 }
 */
