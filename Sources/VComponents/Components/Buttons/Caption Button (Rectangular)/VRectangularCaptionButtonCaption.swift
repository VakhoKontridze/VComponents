//
//  VRectangularCaptionButtonCaption.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI

// MARK: - V Rectangular Caption Button Caption
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VRectangularCaptionButtonCaption<CustomCaption> where CustomCaption: View {
    case title(title: String)
    case icon(icon: Image)
    case titleAndIcon(title: String, icon: Image)
    case custom(custom: (VRectangularCaptionButtonInternalState) -> CustomCaption)
}
