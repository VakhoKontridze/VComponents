//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button
public struct VPlainButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPlainButtonModel
    
    private let state: VPlainButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        model: VPlainButtonModel = .init(),
        state: VPlainButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }

    public init<S>(
        model: VPlainButtonModel = .init(),
        state: VPlainButtonState = .enabled,
        action: @escaping () -> Void,
        title: S
    )
        where
            Content == VGenericTextContent<S>,
            S: StringProtocol
    {
        self.init(
            model: model,
            state: state,
            action: action,
            content: {
                VGenericTextContent(
                    title: title,
                    color: model.colors.textColor(state: .init(state: state, isPressed: false)),
                    font: model.font
                )
            }
        )
    }
}

// MARK:- Body
public extension VPlainButton {
    var body: some View {
        VBaseButton(
            isDisabled: state.isDisabled,
            action: action,
            onPress: { isPressed = $0 },
            content: { hitBox }
        )
    }
    
    private var hitBox: some View {
        buttonView
            .padding(.horizontal, model.layout.hitBoxSpacingX)
            .padding(.vertical, model.layout.hitBoxSpacingY)
    }
    
    private var buttonView: some View {
        content()
            .opacity(model.colors.foregroundOpacity(state: internalState))
    }
}

// MARK:- Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(action: {}, title: "Press")
            .padding()
    }
}
