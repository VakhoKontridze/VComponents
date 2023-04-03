//
//  VRoundedButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Rounded Button Label
@available(tvOS, unavailable)
enum VRoundedButtonLabel<Label> where Label: View {
    case title(title: String)
    case icon(icon: Image)
    case label(label: (VRoundedButtonInternalState) -> Label)
}
