//
//  PresentationHostAnimatedTransitioner.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.03.23.
//

import UIKit

// MARK: - Presentation Host Animated Transitioner
final class PresentationHostAnimatedTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: Properties
    private let allowsHitTests: Bool
    
    // MARK: Initializers
    init(allowsHitTests: Bool) {
        self.allowsHitTests = allowsHitTests
    }
    
    // MARK: View Controller Animated Transitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationVC: UIViewController = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destinationVC.view)
        destinationVC.view.frame = transitionContext.containerView.frame
        
        transitionContext.containerView.backgroundColor = .clear
        transitionContext.containerView.isUserInteractionEnabled = allowsHitTests
        
        transitionContext.completeTransition(true)
    }
}
