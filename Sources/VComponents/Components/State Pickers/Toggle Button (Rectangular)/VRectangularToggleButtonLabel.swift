//
//  VRectangularToggleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI

// MARK: - V Rectangular Toggle Button Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VRectangularToggleButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case custom(custom: (VRectangularToggleButtonInternalState) -> CustomLabel)
}
