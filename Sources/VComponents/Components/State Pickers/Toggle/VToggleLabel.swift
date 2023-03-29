//
//  VToggleLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Toggle Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VToggleLabel<Label> where Label: View {
    case empty
    case title(title: String)
    case label(label: (VToggleInternalState) -> Label)
}
