//
//  VBaseButtonTapGestureRecognizer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import UIKit

// MARK: - UIKit Event Recognizer
final class VBaseButtonTapGestureRecognizer: UITapGestureRecognizer {
    // MARK: Properties
    private var action: () -> Void
    private var pressHandler: (Bool) -> Void
    
    private let maxOutOfBoundsOffsetToRegisterTap: CGFloat = 20
    
    // MARK: Initializers
    init(
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) {
        self.action = action
        self.pressHandler = pressHandler
        super.init(target: nil, action: nil)
    }

    // MARK: Updates
    func update(
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) {
        self.action = action
        self.pressHandler = pressHandler
    }

    // MARK: Touches
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
            let touch: UITouch = touches.first,
            let size: CGSize = view?.frame.size
        else {
            return
        }
        
        if !touch.location(in: view).isOn(size, offset: maxOutOfBoundsOffsetToRegisterTap) {
            state = .ended
            pressHandler(false)
        }
    }
}

// MARK: - Point on Frame
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
}
