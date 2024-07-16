//
//  VCheckBoxLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Check Box Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VCheckBoxLabel<CustomLabel> where CustomLabel: View {
    case empty
    case title(title: String)
    case custom(custom: (VCheckBoxInternalState) -> CustomLabel)
}
