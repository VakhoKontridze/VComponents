//
//  UIKitEventRecognizer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import UIKit

// MARK:- UIKit Event Recognizer
final class UIKitEventRecognizer: UITapGestureRecognizer {
    // MARK: Properties
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    private let allowedOffset: CGFloat = 20
    
    // MARK: Initializers
    init(
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) {
        self.action = action
        self.pressHandler = pressHandler
        super.init(target: nil, action: nil)
    }
}
    
// MARK:- Touches
extension UIKitEventRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
        pressHandler(true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        pressHandler(false)
        action()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .ended
        pressHandler(false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard
            let touch = touches.first,
            let size = view?.frame.size
        else {
            return
        }
        
        let location: CGPoint = touch.location(in: view)
        let isOn: Bool = location.isOn(size, offset: allowedOffset)
        
        if !isOn {
            state = .ended
            pressHandler(false)
        }
    }
}

// MARK:- Point on Frame
private extension CGPoint {
    func isOn(_ frame: CGSize, offset: CGFloat) -> Bool {
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
}
