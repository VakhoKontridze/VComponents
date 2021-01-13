//
//  VBaseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import UIKit

// MARK:- V Base Button
public struct VBaseButton<Content>: View where Content: View {
    // MARK: Properties
    private let isDisabled: Bool
    
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        isDisabled: Bool,
        action: @escaping () -> Void,
        onPress pressHandler: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isDisabled = isDisabled
        self.action = action
        self.pressHandler = pressHandler
        self.content = content
    }

    // MARK:- Body
    public var body: some View {
        content()
            .overlay(UIKitTouchView(isDisabled: isDisabled, action: action, pressHandler: pressHandler))
    }
}


// MARK:- UIKit Touch View
private struct UIKitTouchView: UIViewRepresentable {
    // MARK: Properties
    private let isDisabled: Bool
    
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    // MARK: Initializers
    init(
        isDisabled: Bool,
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) {
        self.isDisabled = isDisabled
        self.action = action
        self.pressHandler = pressHandler
    }
    
    // MARK: Representable
    func makeCoordinator() -> UIKitTouchCoordinator { .init() }
    
    func makeUIView(context: UIViewRepresentableContext<UIKitTouchView>) -> UIView {
        let view: UIView = .init(frame: .zero)
        view.isUserInteractionEnabled = !isDisabled
        view.addGestureRecognizer(context.coordinator.makeGesture(
            action: action,
            pressHandler: pressHandler
        ))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<UIKitTouchView>) {
        uiView.isUserInteractionEnabled = !isDisabled
    }
}

// MARK:- UIKit Touch Coordination
private final class UIKitTouchCoordinator {
    func makeGesture(
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) -> UIKitEventRecognizer {
        .init(
            action: action,
            pressHandler: pressHandler
        )
    }
}

// MARK:- UIKit Event Recognizer
private final class UIKitEventRecognizer: UITapGestureRecognizer {
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

    // MARK:- Touches
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
