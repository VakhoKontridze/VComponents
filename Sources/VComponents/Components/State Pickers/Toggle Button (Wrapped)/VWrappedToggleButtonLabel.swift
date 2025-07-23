//
//  VWrappedToggleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI

// MARK: - V Wrapped Toggle Button Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VWrappedToggleButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case image(image: Image)
    case titleAndImage(title: String, image: Image)
    case custom(builder: (VWrappedToggleButtonInternalState) -> CustomLabel)
}
