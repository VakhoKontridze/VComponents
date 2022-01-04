//
//  VPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Primary Button
/// Large colored button component that performs action when triggered.
///
/// Component can be initialized with content or title.
///
/// Model and state can be passed as parameters.
///
/// Usage example:
///
///     var body: some View {
///         VPrimaryButton(
///             action: { print("Pressed") },
///             title: "Lorem ipsum"
///         )
///             .padding()
///     }
///     
public struct VPrimaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPrimaryButtonModel
    
    private let state: VPrimaryButtonState
    @State private var internalStateRaw: VPrimaryButtonInternalState?
    private var internalState: VPrimaryButtonInternalState { internalStateRaw ?? .default(state: state) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    /// Initializes component with action and content.
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

    /// Initializes component with action and title.
    public init(
        model: VPrimaryButtonModel = .init(),
        state: VPrimaryButtonState = .enabled,
        action: @escaping () -> Void,
        title: String
    )
        where Content == VText
    {
        self.init(
            model: model,
            state: state,
            action: action,
            content: {
                VText(
                    color: model.colors.textContent.for(.default(state: state)),
                    font: model.fonts.title,
                    title: title
                )
            }
        )
    }

    // MARK: Body
    public var body: some View {
        syncInternalStateWithState()
        
        return VBaseButton(
            isEnabled: internalState.isEnabled,
            gesture: gestureHandler,
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
                .opacity(model.colors.content.for(internalState))

            loaderView
        })
            .padding(.horizontal, model.layout.contentMargin.horizontal)
            .padding(.vertical, model.layout.contentMargin.vertical)
    }
    
    @ViewBuilder private var loaderCompensatorView: some View {
        if internalState.isLoading {
            Spacer()
                .frame(width: model.layout.loaderWidth, alignment: .leading)
        }
    }
    
    @ViewBuilder private var loaderView: some View {
        if internalState.isLoading {
            VSpinner(type: .continous(model.spinnerSubModel))
                .frame(width: model.layout.loaderWidth, alignment: .trailing)
        }
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.background.for(internalState))
    }
    
    @ViewBuilder private var border: some View {
        if model.layout.hasBorder {
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWidth)
        }
    }
    
    // MARK: State Syncs
    private func syncInternalStateWithState() {
        DispatchQueue.main.async(execute: {
            if
                internalStateRaw == nil ||
                .init(internalState: internalState) != state
            {
                internalStateRaw = .default(state: state)
            }
        })
    }
    
    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        internalStateRaw = .init(state: state, isPressed: gestureState.isPressed)
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(action: {}, title: "Lorem ipsum")
            .padding()
    }
}
