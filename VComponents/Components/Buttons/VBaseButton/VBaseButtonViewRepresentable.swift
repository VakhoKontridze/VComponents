//
//  VBaseButtonViewRepresentable.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - UIKit Touch View
struct VBaseButtonViewRepresentable: UIViewRepresentable {
    // MARK: Properties
    private let isEnabled: Bool
    
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    @State private var gesture: VBaseButtonTapGestureRecognizer?
    
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
    func makeUIView(context: Context) -> UIView {
        let view: UIView = .init(frame: .zero)
        
        DispatchQueue.main.async(execute: {
            gesture = VBaseButtonTapGestureRecognizer(action: action, pressHandler: pressHandler)
            view.addGestureRecognizer(gesture!)
        })
        
        //setBindedValues(view, context: context)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        setBindedValues(uiView, context: context)
    }
    
    private func setBindedValues(_ view: UIView, context: Context) {
        view.isUserInteractionEnabled = isEnabled
        
        gesture?.update(action: action, pressHandler: pressHandler)
    }
}
