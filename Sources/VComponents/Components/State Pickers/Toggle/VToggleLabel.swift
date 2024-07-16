//
//  VToggleLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Toggle Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VToggleLabel<CustomLabel> where CustomLabel: View {
    case empty
    case title(title: String)
    case custom(custom: (VToggleInternalState) -> CustomLabel)
}
