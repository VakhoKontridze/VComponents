//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Plain Button
/// Plain button component that performs action when triggered
public struct VPlainButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPlainButtonModel
    
    private let state: VPlainButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    /// Initializes component with action and content
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// var body: some View {
    ///     VPlainButton(action: { print("Pressed") }, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///             .foregroundColor(.accentColor)
    ///     })
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VPlainButtonModel = .init()
    /// @State var state: VPlainButtonState = .enabled
    ///
    /// var body: some View {
    ///     VPlainButton(
    ///         model: model,
    ///         state: state,
    ///         action: { print("Pressed") },
    ///         content: {
    ///             Image(systemName: "swift")
    ///                 .resizable()
    ///                 .frame(width: 20, height: 20)
    ///                 .foregroundColor(.accentColor)
    ///         }
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - action: Action to perform when the user triggers button
    ///   - content: View that describes purpose of the action
    public init(
        model: VPlainButtonModel = .init(),
        state: VPlainButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.state = state
        self.action = action
        self.content = content
    }

    /// Initializes component with action and title
    ///
    /// # Usage Example #
    /// Short initialization
    /// ```
    /// var body: some View {
    ///     VPlainButton(action: { print("Pressed") }, title: "Press")
    /// }
    /// ```
    ///
    /// Full initialization
    /// ```
    /// let model: VPlainButtonModel = .init()
    /// @State var state: VPlainButtonState = .enabled
    ///
    /// var body: some View {
    ///     VSecondaryButton(
    ///         model: model,
    ///         state: state,
    ///         action: { print("Pressed") },
    ///         title: "Press"
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - state: Enum that describes state, such as enabled or disabled
    ///   - action: Action to perform when the user triggers button
    ///   - title: Title that describes purpose of the action
    public init(
        model: VPlainButtonModel = .init(),
        state: VPlainButtonState = .enabled,
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
extension VPlainButton {
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
        content()
            .opacity(model.colors.contentOpacity(state: internalState))
    }
}

// MARK:- Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(action: {}, title: "Press")
            .padding()
    }
}
