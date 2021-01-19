//
//  UIKitTouchView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK:- UIKit Touch View
struct UIKitTouchView: UIViewRepresentable {
    // MARK: Properties
    private let isEnabled: Bool
    
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    // MARK: Initializers
    init(
        isEnabled: Bool,
        action: @escaping () -> Void,
        pressHandler: @escaping (Bool) -> Void
    ) {
        self.isEnabled = isEnabled
        self.action = action
        self.pressHandler = pressHandler
    }
    
    // MARK: Representable
    func makeUIView(context: UIViewRepresentableContext<UIKitTouchView>) -> UIView {
        let view: UIView = .init(frame: .zero)
        view.isUserInteractionEnabled = isEnabled
        view.addGestureRecognizer(UIKitEventRecognizer(
            action: action,
            pressHandler: pressHandler
        ))
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<UIKitTouchView>) {
        uiView.isUserInteractionEnabled = isEnabled
    }
}
