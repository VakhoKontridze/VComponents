//
//  VCapsuleButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Capsule Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VCapsuleButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VCapsuleButtonInternalState) -> Label)
}
