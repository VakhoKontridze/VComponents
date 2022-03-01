//
//  VBaseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK: - V Base Button
/// Core component that is used throughout the library as button.
///
/// `Bool` can also be passed as state.
///
/// Usage example:
///
///     var body: some View {
///         VBaseButton(
///             gesture: { gestureState in
///                 switch gestureState {
///                 case .none: print("-")
///                 case .press: print("Pressing")
///                 case .click: print("Clicked")
///                 }
///             },
///             content: { Text("Lorem Ipsum") }
///         )
///     }
///
/// If observing pressed state is not desired, API can be simplified:
///
///     var body: some View {
///         VBaseButton(
///             action: { print("Clicked") },
///             content: { Text("Lorem Ipsum") }
///         )
///     }
///
public struct VBaseButton<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private var gestureHandler: (VBaseButtonGestureState) -> Void
    
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with gesture handler and content.
    public init(
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.gestureHandler = gestureHandler
        self.content = content
    }
    
    /// Initializes component with action and content.
    public init(
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.gestureHandler = { gestureState in if gestureState.isClicked { action() } }
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        content()
            .overlay(VBaseButtonViewRepresentable(
                isEnabled: isEnabled,
                gesture: gestureHandler
            ))
    }
}

// MARK: - Preview
struct VBaseButton_Previews: PreviewProvider {
    static var previews: some View {
        VBaseButton(
            gesture: { gestureState in
                switch gestureState {
                case .none: print("-")
                case .press: print("Pressing")
                case .click: print("Clicked")
                }
            },
            content: { Text("Lorem Ipsum") }
        )
    }
}
