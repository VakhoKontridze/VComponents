//
//  VSquareButtonBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Square Button Bordered
struct VSquareButtonBordered<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSquareButtonModelBordered
    
    private let state: VSquareButtonState
    @State private var isPressed: Bool = false
    private var internalState: VSquareButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VSquareButtonModelBordered,
        state: VSquareButtonState,
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
extension VSquareButtonBordered {
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
            .overlay(border)
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
    
    @ViewBuilder private var border: some View {
        switch model.layout.borderType {
        case .continous:
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.borderColor(state: internalState), lineWidth: model.layout.borderWidth)
            
        case .dashed(let spacing):
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(
                    model.colors.borderColor(state: internalState),
                    style: .init(lineWidth: model.layout.borderWidth, dash: [spacing])
                )
        }
    }
}

// MARK:- Preview
struct VSquareButtonBordered_Previews: PreviewProvider {
    private static let roundedModel: VSquareButtonModelBordered = .init(
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
            VSquareButtonBordered(model: .init(), state: .enabled, action: {}, content: { content })
            
            VSquareButtonBordered(model: roundedModel, state: .enabled, action: {}, content: { content })
        })
    }
}
