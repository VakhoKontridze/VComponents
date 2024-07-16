//
//  VLoadingStretchedButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import SwiftUI

// MARK: - V Loading Stretched Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VLoadingStretchedButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case titleAndIcon(title: String, icon: Image)
    case custom(custom: (VLoadingStretchedButtonInternalState) -> CustomLabel)
}
