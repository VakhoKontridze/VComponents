//
//  VDisclosureGroupHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/6/22.
//

import SwiftUI

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VDisclosureGroupHeaderLabel<CustomHeaderLabel> where CustomHeaderLabel: View {
    case title(title: String)
    case custom(builder: (VDisclosureGroupInternalState) -> CustomHeaderLabel)
}
