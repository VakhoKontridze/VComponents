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
enum VDisclosureGroupHeaderLabel<CustomHeaderLabel> where CustomHeaderLabel: View {
    case title(title: String)
    case custom(custom: (VDisclosureGroupInternalState) -> CustomHeaderLabel)
}
