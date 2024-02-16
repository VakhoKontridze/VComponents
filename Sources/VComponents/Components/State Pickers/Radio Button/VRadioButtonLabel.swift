//
//  VRadioButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Radio Button Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VRadioButtonLabel<Label> where Label: View {
    case empty
    case title(title: String)
    case label(label: (VRadioButtonInternalState) -> Label)
}
