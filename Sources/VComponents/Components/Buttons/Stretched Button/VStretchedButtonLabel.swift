//
//  VStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

import SwiftUI

@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VStretchedButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case image(image: Image)
    case titleAndImage(title: String, image: Image)
    case custom(builder: (VStretchedButtonInternalState) -> CustomLabel)
}
