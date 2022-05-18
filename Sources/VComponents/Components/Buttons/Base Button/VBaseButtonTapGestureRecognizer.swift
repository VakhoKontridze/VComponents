//
//  VBaseButtonTapGestureRecognizer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import UIKit

// MARK: - V Base Button Tap Gesture Recognizer
final class VBaseButtonTapGestureRecognizer: UITapGestureRecognizer, UIGestureRecognizerDelegate {
    // MARK: Properties
    private var gestureHandler: (VBaseButtonGestureState) -> Void
    
    private let maxOutOfBoundsOffsetToRegisterTap: CGFloat = 10
    
    private var initialTouchViewCenterLocationOnSuperView: CGPoint?
    private let maxOffsetToRegisterTapInScrollView: CGFloat = 5
    
    // MARK: Initializers
    init(
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void
    ) {
        self.gestureHandler = gestureHandler
        super.init(target: nil, action: nil)
        setUp()
    }
    
    // MARK: Setup
    private func setUp() {
        delegate = self
    }
    
    // MARK: Updates
    func update(
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void
    ) {
        self.gestureHandler = gestureHandler
    }

    // MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
        initialTouchViewCenterLocationOnSuperView = view?.centerLocationOnSuperView
        gestureHandler(.press)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if
            touchIsOnView(touches) == false ||
            gestureViewLocationIsUnchanged == false
        {
            state = .ended
            initialTouchViewCenterLocationOnSuperView = nil
            gestureHandler(.none)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        switch gestureViewLocationIsUnchanged {
        case nil:
            break
            
        case true?:
            state = .ended
            initialTouchViewCenterLocationOnSuperView = nil
            gestureHandler(.click)
            
        case false?:
            state = .ended
            initialTouchViewCenterLocationOnSuperView = nil
            gestureHandler(.none)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        initialTouchViewCenterLocationOnSuperView = nil
        gestureHandler(.none)
    }
    
    // MARK: Gesture Recognizer Delegate
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
    
    // MARK: Touch Detection
    private var gestureViewLocationIsUnchanged: Bool? {
        guard
            let initialTouchViewCenterLocationOnSuperView = initialTouchViewCenterLocationOnSuperView,
            let location: CGPoint = view?.centerLocationOnSuperView
        else {
            return nil
        }

        return location.equals(initialTouchViewCenterLocationOnSuperView, tolerance: maxOffsetToRegisterTapInScrollView)
    }
    
    private func touchIsOnView(_ touches: Set<UITouch>) -> Bool? {
        guard
            let touch: UITouch = touches.first,
            let view: UIView = view
        else {
            return nil
        }
        
        return touch
            .location(in: view)
            .isOn(view.frame.size, offset: maxOutOfBoundsOffsetToRegisterTap)
    }
}

// MARK: - Helpers
extension CGPoint {
    fileprivate func isOn(_ frame: CGSize, offset: CGFloat) -> Bool {
        let xIsOnTarget: Bool = {
            let isPositive: Bool = x >= 0
            switch isPositive {
            case false: return x >= -offset
            case true: return x <= frame.width + offset
            }
        }()

        let yIsOnTarget: Bool = {
            let isPositive: Bool = y >= 0
            switch isPositive {
            case false: return y >= -offset
            case true: return y <= frame.height + offset
            }
        }()

        return xIsOnTarget && yIsOnTarget
    }
    
    fileprivate func equals(_ other: CGPoint, tolerance: CGFloat) -> Bool {
        abs(x - other.x) < tolerance &&
        abs(y - other.y) < tolerance
    }
}

extension UIView {
    fileprivate var centerLocationOnSuperView: CGPoint? {
        superview?.convert(center, to: nil)
    }
}
