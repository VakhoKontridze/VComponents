//
//  VRoundedLabeledButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI

// MARK: - V Rounded Labeled Button Label
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VRoundedLabeledButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VRoundedLabeledButtonInternalState) -> Label)
}
