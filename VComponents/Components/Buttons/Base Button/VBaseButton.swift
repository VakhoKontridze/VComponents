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
///             label: { Text("Lorem Ipsum") }
///         )
///     }
///
/// If observing pressed state is not desired, API can be simplified:
///
///     var body: some View {
///         VBaseButton(
///             action: { print("Clicked") },
///             label: { Text("Lorem Ipsum") }
///         )
///     }
///
public struct VBaseButton<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private var gestureHandler: (VBaseButtonGestureState) -> Void
    
    private let label: () -> Label
    
    // MARK: Initializers
    /// Initializes component with gesture handler and label.
    public init(
        gesture gestureHandler: @escaping (VBaseButtonGestureState) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.gestureHandler = gestureHandler
        self.label = label
    }
    
    /// Initializes component with action and label.
    public init(
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.gestureHandler = { gestureState in if gestureState.isClicked { action() } }
        self.label = label
    }

    // MARK: Body
    public var body: some View {
        label()
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
            label: { Text("Lorem Ipsum") }
        )
    }
}
