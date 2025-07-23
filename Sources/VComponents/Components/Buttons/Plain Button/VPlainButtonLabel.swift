//
//  VPlainButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Plain Button Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VPlainButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case image(image: Image)
    case titleAndImage(title: String, image: Image)
    case custom(builder: (VPlainButtonInternalState) -> CustomLabel)
}
