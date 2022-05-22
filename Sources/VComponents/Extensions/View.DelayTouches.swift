//
//  View.DelayTouches.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.05.22.
//

import SwiftUI

// MARK: - View Delay Touches
extension View {
    // Allows `DragGesture` to work with `ScrollView`
    func delayTouches() -> some View {
        Button(
            action: {},
            label: { highPriorityGesture(TapGesture()) }
        )
            .buttonStyle(NoButtonStyle())
    }
}

private struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
