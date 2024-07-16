//
//  VRectangularButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Rectangular Button Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VRectangularButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case custom(custom: (VRectangularButtonInternalState) -> CustomLabel)
}
