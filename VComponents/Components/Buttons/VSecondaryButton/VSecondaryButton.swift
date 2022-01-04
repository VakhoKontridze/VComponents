//
//  VSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Secondary Button
/// Small colored button component that performs action when triggered.
///
/// Component can be initialized with content or title.
///
/// Model and state can be passed as parameters.
///
/// Usage example:
///
///     var body: some View {
///         VSecondaryButton(
///             action: { print("Pressed") },
///             title: "Lorem ipsum"
///         )
///     }
///     
public struct VSecondaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSecondaryButtonModel
    
    private let state: VSecondaryButtonState
    @State private var internalStateRaw: VSecondaryButtonInternalState?
    private var internalState: VSecondaryButtonInternalState { internalStateRaw ?? .default(state: state) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    /// Initializes component with action and content.
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

    /// Initializes component with action and title.
    public init(
        model: VSecondaryButtonModel = .init(),
        state: VSecondaryButtonState = .enabled,
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
            content: { hitBoxButtonView }
        )
    }
    
    private var hitBoxButtonView: some View {
        buttonView
            .padding(.horizontal, model.layout.hitBox.horizontal)
            .padding(.vertical, model.layout.hitBox.vertical)
    }
    
    private var buttonView: some View {
        buttonContent
            .frame(height: model.layout.height)
            .background(backgroundView)
            .overlay(border)
    }
    
    private var buttonContent: some View {
        content()
            .padding(.horizontal, model.layout.contentMargins.horizontal)
            .padding(.vertical, model.layout.contentMargins.vertical)
            .opacity(model.colors.content.for(internalState))
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
struct VSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButton(action: {}, title: "Lorem ipsum")
            .padding()
    }
}
