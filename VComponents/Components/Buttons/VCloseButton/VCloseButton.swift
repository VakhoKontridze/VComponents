//
//  VCloseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK:- V Close Button
/// Circular colored close button component that performs action when triggered
public struct VCloseButton: View {
    // MARK: Properties
    private let model: VCloseButtonModel

    private let state: VCloseButtonState
    @State private var isPressed: Bool = false
    private var internalState: VCloseButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    // MARK: Initializers
    /// Initializes component with action
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// var body: some View {
    ///     VCloseButton(action: { print("Pressed") })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VChevronButtonModel = .init()
    /// @State var state: VPlainButtonState = .enabled
    ///
    /// var body: some View {
    ///     VChevronButton(
    ///         model: model,
    ///         state: state,
    ///         action: { print("Pressed") }
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - direction: Enum that describes direction, such as left, right, up, or down
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - action: Action to perform when the user triggers button
    public init(
        model: VCloseButtonModel = .init(),
        state: VCloseButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.state = state
        self.action = action
    }
}

// MARK:- Body
extension VCloseButton {
    public var body: some View {
        VBaseButton(
            isEnabled: state.isEnabled,
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
            .frame(dimension: model.layout.dimension)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        Image(systemName: "xmark")
            .font(model.font)
            .foregroundColor(model.colors.foregroundColor(state: internalState))
            .opacity(model.colors.foregroundOpacity(state: internalState))
    }
    
    private var backgroundView: some View {
        Circle()
            .foregroundColor(model.colors.backgroundColor(state: internalState))
    }
}

// MARK:- Preview
struct VCloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VCloseButton(action: {})
            .padding()
    }
}
