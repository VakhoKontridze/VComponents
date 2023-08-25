//
//  VRectangularToggleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI

// MARK: - V Rectangular Toggle Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VRectangularToggleButtonLabel<Label> where Label: View {
    case title(title: String)
    case icon(icon: Image)
    case label(label: (VRectangularToggleButtonInternalState) -> Label)
}
