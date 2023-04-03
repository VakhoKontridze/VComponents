//
//  VStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

import SwiftUI

// MARK: - V Stretched Button Label
@available(tvOS, unavailable)
enum VStretchedButtonLabel<Label> where Label: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case label(label: (VStretchedButtonInternalState) -> Label)
}
