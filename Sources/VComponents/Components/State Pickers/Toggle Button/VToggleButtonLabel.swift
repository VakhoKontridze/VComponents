//
//  VToggleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI

// MARK: - V Toggle Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VToggleButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VToggleButtonInternalState) -> Label)
}
