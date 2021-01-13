//
//  VCloseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Close Button
public struct VCloseButton: View {
    // MARK: Properties
    private let model: VCloseButtonModel

    private let state: VCloseButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCloseButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    // MARK: Direction
    public init(
        model: VCloseButtonModel = .init(),
        state: VCloseButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.action = action
    }
}

// MARK:- Body
extension VCloseButton {
    public var body: some View {
        VBaseButton(
            isDisabled: state.isDisabled,
            action: action,
            onPress: { isPressed = $0 },
            content: { hitBox }
        )
    }
    
    private var hitBox: some View {
        buttonView
            .padding(.horizontal, model.layout.hitBoxHor)
            .padding(.vertical, model.layout.hitBoxVer)
    }
    
    private var buttonView: some View {
        buttonContent
            .frame(dimension: model.layout.dimension)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        Image(systemName: "xmark")
            .font(model.font)
            .foregroundColor(model.colors.foregroundColor(state: internalState))
            .opacity(model.colors.foregroundOpacity(state: internalState))
    }
    
    private var backgroundView: some View {
        Circle()
            .foregroundColor(model.colors.backgroundColor(state: internalState))
    }
}

// MARK:- Preview
struct VCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButton(action: {})
            .padding()
    }
}
