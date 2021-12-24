//
//  VCloseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Close Button
/// Circular colored close button component that performs action when triggered.
///
/// Model and state can be passed as parameters.
///
/// Usage example:
///
///     var body: some View {
///         VCloseButton(action: {
///             print("Pressed")
///         })
///     }
///     
public struct VCloseButton: View {
    // MARK: Properties
    private let model: VCloseButtonModel

    private let state: VCloseButtonState
    @State private var internalStateRaw: VCloseButtonInternalState?
    private var internalState: VCloseButtonInternalState { internalStateRaw ?? .default(state: state) }
    
    private let action: () -> Void
    
    // MARK: Initializers
    /// Initializes component with action.
    public init(
        model: VCloseButtonModel = .init(),
        state: VCloseButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.action = action
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
            .frame(dimension: model.layout.dimension)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        ImageBook.xMark
            .resizable()
            .frame(dimension: model.layout.iconDimension)
            .foregroundColor(model.colors.content.for(internalState))
            .opacity(model.colors.content.for(internalState))
    }
    
    private var backgroundView: some View {
        Circle()
            .foregroundColor(model.colors.background.for(internalState))
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
struct VCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButton(action: {})
            .padding()
    }
}
