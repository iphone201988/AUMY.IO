import UIKit
import Foundation

class SharedMethods {
    
    static var shared = SharedMethods()
    
    var isLoggedIn: Bool {
        let token = UserDefaults.standard[.accessToken] ?? ""
        if token.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func navigateToRootVC(rootVC: UIViewController) {
        // Ensure the key window scene is used
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.navigationBar.isHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    func pushToWithoutData(destVC: UIViewController.Type,
                           storyboard: AppStoryboards = .main,
                           isAnimated: Bool = false) {
        DispatchQueue.main.async {
            if let vc = storyboard.controller(destVC.self) {
                SharedMethods.shared.pushTo(destVC: vc, isAnimated: isAnimated)
            }
        }
    }
    
    func pushTo(destVC: UIViewController, isAnimated: Bool = false) {
        guard let rootViewController = getWindowRootViewController() else { return }
        guard let topController = getTopViewController(from: rootViewController) else { return }
        
        // Check if the destination view controller is already in the stack
        if let existingVC = topController.navigationController?.viewControllers.first(where: { $0.isKind(of: destVC.classForCoder) }) {
            // If it exists in the stack, pop to that view controller
            DispatchQueue.main.async {
                topController.navigationController?.popToViewController(existingVC, animated: isAnimated)
            }
        } else {
            // Otherwise, push the new view controller
            DispatchQueue.main.async {
                topController.navigationController?.navigationBar.isHidden = true
                topController.navigationController?.pushViewController(destVC, animated: isAnimated)
            }
        }
    }
    
    func presentVC(destVC: UIViewController,
                   modalPresentationStyle: UIModalPresentationStyle = .popover,
                   isAnimated: Bool = false) {
        guard let rootViewController = getWindowRootViewController() else { return }
        guard let topController = getTopViewController(from: rootViewController) else { return }
        DispatchQueue.main.async {
            destVC.modalPresentationStyle = modalPresentationStyle
            destVC.modalTransitionStyle = .coverVertical
            topController.present(destVC, animated: isAnimated)
        }
    }
    
    func shareMovie(movieTitle: String, description: String, posterImage: UIImage?, link: URL) {
        guard let rootViewController = getWindowRootViewController() else { return }
        guard let topController = getTopViewController(from: rootViewController) else { return }
        
        let customItemSource = CustomMovieActivityItemSource(
            title: movieTitle,
            description: description,
            url: link,
            image: posterImage
        )
        
        let activityVC = UIActivityViewController(activityItems: [customItemSource], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            .assignToContact,
            .saveToCameraRoll,
            .print,
            .addToReadingList
        ]
        
        // iPad compatibility
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = topController.view
            popover.sourceRect = CGRect(x: topController.view.bounds.midX,
                                        y: topController.view.bounds.maxY - 40,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }
        
        topController.present(activityVC, animated: true, completion: nil)
    }
    
    func createGradientLayer(from color: UIColor, frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [
            color.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }
    
    func gradientColor(from color: UIColor, to endColor: UIColor = .black, size: CGSize) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = [color.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return color }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image ?? UIImage())
    }
    
    func gradientWithHaptic(parentView: UIView, completion: @escaping () -> Void) {
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Create gradient overlay
        let gradientOverlay = CAGradientLayer()
        gradientOverlay.frame = parentView.bounds
        gradientOverlay.colors = [
            UIColor(named: "0A01D6")?.withAlphaComponent(0.3).cgColor ?? UIColor.systemBlue.cgColor,
            UIColor(named: "6800E9")?.withAlphaComponent(0.3).cgColor ?? UIColor.systemBlue.cgColor,
            UIColor.systemPurple.withAlphaComponent(0.0).cgColor
        ]
        
        gradientOverlay.startPoint = CGPoint(x: 0, y: 0.5)  // left middle
        gradientOverlay.endPoint = CGPoint(x: 1, y: 0.5)    // right middle
        
        let overlayView = UIView(frame: parentView.bounds)
        overlayView.layer.addSublayer(gradientOverlay)
        overlayView.alpha = 0
        parentView.addSubview(overlayView)
        
        // Animate fade-in and fade-out
        UIView.animate(withDuration: 0.15, animations: {
            overlayView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
                //completion()
            }
        }
        completion()
    }
}
