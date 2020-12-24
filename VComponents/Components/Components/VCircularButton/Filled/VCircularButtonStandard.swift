//
//  VCircularButtonFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Circular Button Standard
struct VCircularButtonFilled<Content>: View where Content: View {
    // MARK: Properties
    private let model: VCircularButtonFilledModel
    
    private let state: VCircularButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCircularButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VCircularButtonFilledModel,
        state: VCircularButtonState,
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
extension VCircularButtonFilled {
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
            .frame(dimension: model.layout.dimension)
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
            .foregroundColor(model.colors.fillColor(state: internalState))
    }
}

// MARK:- Preview
struct VCircularButtonFilled_Previews: PreviewProvider {
    private static let roundedModel: VCircularButtonFilledModel = .init(
        layout: .init(
            frame: .rounded()
        )
    )
    
    private static var content: some View {
        Image(systemName: "swift")
            .resizable()
            .frame(size: .init(width: 20, height: 20))
            .foregroundColor(ColorBook.primaryInverted)
    }
    
    static var previews: some View {
        HStack(content: {
            VCircularButtonFilled(model: .init(), state: .enabled, action: {}, content: { content })
            
            VCircularButtonFilled(model: roundedModel, state: .enabled, action: {}, content: { content })
        })
    }
}
