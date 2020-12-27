//
//  VSecondaryButtonFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Secondary Button Filled
struct VSecondaryButtonFilled<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSecondaryButtonModelFilled
    
    private let state: VSecondaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VSecondaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VSecondaryButtonModelFilled,
        state: VSecondaryButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }
}

// MARK:- Body
extension VSecondaryButtonFilled {
    var body: some View {
        VInteractiveView(
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
        buttonContent
            .frame(height: model.layout.height)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        VGenericButtonContentView(
            foregroundColor: model.colors.foregroundColor(state: internalState),
            foregroundOpacity: model.colors.foregroundOpacity(state: internalState),
            font: model.fonts.title,
            content: content
        )
            .padding(.horizontal, model.layout.contentMarginX)
            .padding(.vertical, model.layout.contentMarginY)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.backgroundColor(state: internalState))
    }
}

// MARK:- Preview
struct VSecondaryButtonFilled_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButtonFilled(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
    }
}
