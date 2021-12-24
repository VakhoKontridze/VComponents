//
//  VBaseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import UIKit

// MARK: - V Base Button
/// Core component that is used throughout the library as button.
///
/// `Bool` can also be passed as state.
///
/// Usage example:
///
///     @State var state: VBaseButtonState = .enabled
///
///     var body: some View {
///         VBaseButton(
///             state: state,
///             gesture: { gestureState in
///                 switch gestureState {
///                 case .none: print("-")
///                 case .press: print("Pressing")
///                 case .click: print("Clicked")
///                 }
///             },
///             content: { Text("Lorem ipsum") }
///         )
///     }
///
/// If observing pressed state is not desired, API can be simplified:
///
///     var body: some View {
///         VBaseButton(
///             state: state,
///             action: { print("Clicked") },
///             content: { Text("Lorem ipsum") }
///         )
///     }
///
public struct VBaseButton<Content>: View where Content: View {
    // MARK: Properties
    private let state: VBaseButtonState
    
    private var gestureHandler: (VBaseButtonGestureState) -> Void
    
    private let content: () -> Content
    
    // MARK: Initializers - State
    /// Initializes component with state, gesture handler, and content.
    public init(
        state: VBaseButtonState,
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.gestureHandler = gestureHandler
        self.content = content
    }
    
    /// Initializes component with state, action, and content.
    public init(
        state: VBaseButtonState,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.gestureHandler = { gestureState in if gestureState.isClicked { action() } }
        self.content = content
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with bool, gesture handler, and content.
    public init(
        isEnabled: Bool,
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = .init(isEnabled: isEnabled)
        self.gestureHandler = gestureHandler
        self.content = content
    }
    
    /// Initializes component with bool, action, and content.
    public init(
        isEnabled: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = .init(isEnabled: isEnabled)
        self.gestureHandler = { gestureState in if gestureState.isClicked { action() } }
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        content()
            .overlay(VBaseButtonViewRepresentable(
                isEnabled: state.isEnabled,
                gesture: gestureHandler
            ))
    }
}

// MARK: - Preview
struct VBaseButton_Previews: PreviewProvider {
    @State private static var state: VBaseButtonState = .enabled
    
    static var previews: some View {
        VBaseButton(
            state: state,
            gesture: { gestureState in
                switch gestureState {
                case .none: print("-")
                case .press: print("Pressing")
                case .click: print("Clicked")
                }
            },
            content: { Text("Lorem ipsum") }
        )
    }
}
