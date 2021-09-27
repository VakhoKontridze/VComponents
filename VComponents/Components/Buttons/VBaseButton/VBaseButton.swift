//
//  VBaseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import UIKit

// MARK: - V Base Button
/// Core component that is used throughout the framework as button
///
/// Bool can also be passed as state
///
/// # Usage Example #
///
/// ```
/// @State var state: VBaseButtonState = .enabled
///
/// var body: some View {
///     VBaseButton(
///         state: state,
///         action: { print("Pressed") },
///         onPress: { isPressed in
///             switch isPressed {
///             case false: print("Press ended")
///             case true: print("Press began")
///             }
///         },
///         content: { Text("Lorem ipsum") }
///     )
/// }
/// ```
///
public struct VBaseButton<Content>: View where Content: View {
    // MARK: Properties
    private let state: VBaseButtonState
    
    private let action: () -> Void
    private let pressHandler: (Bool) -> Void
    
    private let content: () -> Content
    
    // MARK: Initializers - State
    /// Initializes component with state, action, press handler, and content
    public init(
        state: VBaseButtonState,
        action: @escaping () -> Void,
        onPress pressHandler: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.action = action
        self.pressHandler = pressHandler
        self.content = content
    }
    
    // MARK: Initializers - Bool
    /// Initializes component with bool, action, press handler, and content
    public init(
        isEnabled: Bool,
        action: @escaping () -> Void,
        onPress pressHandler: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = .init(isEnabled: isEnabled)
        self.action = action
        self.pressHandler = pressHandler
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        content()
            .overlay(UIKitTouchView(isEnabled: state.isEnabled, action: action, pressHandler: pressHandler))
    }
}

// MARK: - Preview
struct VBaseButton_Previews: PreviewProvider {
    @State private static var state: VBaseButtonState = .enabled
    
    static var previews: some View {
        VBaseButton(
            state: state,
            action: { print("Pressed") },
            onPress: { isPressed in
                switch isPressed {
                case false: print("Press ended")
                case true: print("Press began")
                }
            },
            content: { Text("Lorem ipsum") }
        )
    }
}
