//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Plain Button
/// Plain button component that performs action when triggered.
///
/// Component can be initialized with content or title.
///
/// Model and state can be passed as parameters.
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     VPlainButton(
///         action: { print("Pressed") },
///         title: "Lorem ipsum"
///     )
/// }
/// ```
///
public struct VPlainButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPlainButtonModel
    
    private let state: VPlainButtonState
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(state: state, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: () -> Content

    // MARK: Initializers
    /// Initializes component with action and content.
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

    /// Initializes component with action and title.
    public init(
        model: VPlainButtonModel = .init(),
        state: VPlainButtonState = .enabled,
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
                    type: .oneLine,
                    font: model.fonts.title,
                    color: model.colors.textContent.for(.init(state: state, isPressed: false)),
                    title: title
                )
            }
        )
    }

    // MARK: Body
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
            .padding(.horizontal, model.layout.hitBox.horizontal)
            .padding(.vertical, model.layout.hitBox.vertical)
    }
    
    private var buttonView: some View {
        content()
            .opacity(model.colors.content.for(internalState))
    }
}

// MARK: - Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(action: {}, title: "Lorem ipsum")
            .padding()
    }
}
