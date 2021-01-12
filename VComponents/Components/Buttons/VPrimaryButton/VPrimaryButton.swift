//
//  VPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Primary Button
public struct VPrimaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPrimaryButtonModel
    
    private let state: VPrimaryButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPrimaryButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    public init(
        model: VPrimaryButtonModel = .init(),
        state: VPrimaryButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }

    public init(
        model: VPrimaryButtonModel = .init(),
        state: VPrimaryButtonState = .enabled,
        action: @escaping () -> Void,
        title: String
    )
        where Content == VBaseText
    {
        self.init(
            model: model,
            state: state,
            action: action,
            content: {
                VBaseText(
                    title: title,
                    color: model.colors.textColor(state: .init(state: state, isPressed: false)),
                    font: model.font
                )
            }
        )
    }
}

// MARK:- Body
extension VPrimaryButton {
    public var body: some View {
        VBaseButton(
            isDisabled: state.isDisabled,
            action: action,
            onPress: { isPressed = $0 },
            content: { buttonView }
        )
    }
    
    private var buttonView: some View {
        buttonContent
            .frame(height: model.layout.height)
            .background(backgroundView)
            .overlay(border)
    }
    
    private var buttonContent: some View {
        HStack(alignment: .center, spacing: model.layout.loaderSpacing, content: {
            loaderCompensatorView

            content()
                .frame(maxWidth: .infinity)
                .opacity(model.colors.contentOpacity(state: internalState))

            loaderView
        })
            .padding(.horizontal, model.layout.contentMarginHor)
            .padding(.vertical, model.layout.contentMarginVer)
    }
    
    @ViewBuilder private var loaderCompensatorView: some View {
        if internalState.isLoading {
            Spacer()
                .frame(width: model.layout.loaderWidth, alignment: .leading)
        }
    }
    
    @ViewBuilder private var loaderView: some View {
        if internalState.isLoading {
            VSpinner(model: .continous(model.spinnerModel))
                .frame(width: model.layout.loaderWidth, alignment: .trailing)
        }
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
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(action: {}, title: "Press")
            .padding()
    }
}
