//
//  VLoadingStretchedButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import SwiftUI

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VLoadingStretchedButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case image(image: Image)
    case titleAndImage(title: String, image: Image)
    case custom(builder: (VLoadingStretchedButtonInternalState) -> CustomLabel)
}
