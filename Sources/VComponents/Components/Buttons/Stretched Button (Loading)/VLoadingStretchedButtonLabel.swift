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
enum VLoadingStretchedButtonLabel<Label> where Label: View {
    case title(title: String)
    case icon(icon: Image)
    case iconTitle(icon: Image, title: String)
    case label(label: (VLoadingStretchedButtonInternalState) -> Label)
}
