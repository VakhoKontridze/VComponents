//
//  VRectangularButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VRectangularButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case image(image: Image)
    case custom(builder: (VRectangularButtonInternalState) -> CustomLabel)
}
