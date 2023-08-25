//
//  VWrappedButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Wrapped Button Label
@available(tvOS, unavailable)
enum VWrappedButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VWrappedButtonInternalState) -> Label)
}
