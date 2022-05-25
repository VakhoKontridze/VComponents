//
//  VBaseButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Base Button
/// Core component that is used throughout the library as button.
///
/// `Bool` can also be passed as state.
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
public typealias VBaseButton = VCore.SwiftUIBaseButton

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
