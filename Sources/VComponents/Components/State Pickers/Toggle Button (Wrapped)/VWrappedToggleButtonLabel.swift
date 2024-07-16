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
    case icon(icon: Image)
    case titleAndIcon(title: String, icon: Image)
    case custom(custom: (VWrappedToggleButtonInternalState) -> CustomLabel)
}
