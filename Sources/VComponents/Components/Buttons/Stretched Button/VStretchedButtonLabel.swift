//
//  VStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

import SwiftUI

// MARK: - V Stretched Button Label
@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum VStretchedButtonLabel<Label> where Label: View {
    case title(title: String)
    case icon(icon: Image)
    case titleAndIcon(title: String, icon: Image)
    case label(label: (VStretchedButtonInternalState) -> Label)
}
