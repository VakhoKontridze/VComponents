//
//  VDisclosureGroupHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/6/22.
//

import SwiftUI

// MARK: - V Disclosure Group Header Label
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VDisclosureGroupHeaderLabel<Label> where Label: View {
    case title(title: String)
    case label(label: (VDisclosureGroupInternalState) -> Label)
}
