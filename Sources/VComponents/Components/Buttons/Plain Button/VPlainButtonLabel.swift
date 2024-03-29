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
enum VPlainButtonLabel<Label> where Label: View {
    case title(title: String)
    case icon(icon: Image)
    case titleAndIcon(title: String, icon: Image)
    case label(label: (VPlainButtonInternalState) -> Label)
}
