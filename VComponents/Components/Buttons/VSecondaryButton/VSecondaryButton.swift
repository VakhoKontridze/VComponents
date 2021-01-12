//
//  VSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button
public struct VSecondaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSecondaryButtonModel
    
    private let state: VSecondaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VSecondaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        model: VSecondaryButtonModel = .init(),
        state: VSecondaryButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }

    public init(
        model: VSecondaryButtonModel = .init(),
        state: VSecondaryButtonState = .enabled,
        action: @escaping () -> Void,
        title: String
    )
        where Content == VBaseTitle
    {
        self.init(
            model: model,
            state: state,
            action: action,
            content: {
                VBaseTitle(
                    title: title,
                    color: model.colors.textColor(state: .init(state: state, isPressed: false)),
                    font: model.font,
                    type: .oneLine
                )
            }
        )
    }
}

// MARK:- Body
extension VSecondaryButton {
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
            .frame(height: model.layout.height)
            .background(backgroundView)
            .overlay(border)
    }
    
    private var buttonContent: some View {
        content()
            .padding(.horizontal, model.layout.contentMarginHor)
            .padding(.vertical, model.layout.contentMarginVer)
            .opacity(model.colors.contentOpacity(state: internalState))
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.backgroundColor(state: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if model.layout.hasBorder {
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.borderColor(state: internalState), lineWidth: model.layout.borderWidth)
        }
    }
}

// MARK:- Preview
struct VSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButton(action: {}, title: "Press")
            .padding()
    }
}
