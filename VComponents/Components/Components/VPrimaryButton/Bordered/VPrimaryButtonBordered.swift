//
//  VPrimaryButtonBordered.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Primary Button Bordered
struct VPrimaryButtonBordered<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPrimaryButtonBorderedModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPrimaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    init(
        model: VPrimaryButtonBorderedModel,
        state: VPrimaryButtonState,
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
extension VPrimaryButtonBordered {
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
            .overlay(border)
    }
    
    private var buttonContent: some View {
        HStack(alignment: .center, spacing: model.layout.loaderSpacing, content: {
            VPrimaryButtonLoaderCompensatorView(
                isVisible: internalState.isLoading,
                width: model.layout.loaderWidth
            )

            VGenericButtonContentView(
                foregroundColor: model.colors.foregroundColor(state: internalState),
                foregroundOpacity: model.colors.foregroundOpacity(state: internalState),
                font: model.fonts.title,
                content: content
            )
                .frame(maxWidth: .infinity)

            VPrimaryButtonLoaderView(
                loaderColor: model.colors.loader.color,
                width: model.layout.loaderWidth,
                isVisible: internalState.isLoading
            )
        })
            .padding(.horizontal, model.layout.contentMarginX)
            .padding(.vertical, model.layout.contentMarginY)
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.fillColor(state: internalState))
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
struct VPrimaryButtonBordered_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonBordered(model: .init(), state: .enabled, action: {}, content: { Text("Press") })
            .padding()
    }
}
