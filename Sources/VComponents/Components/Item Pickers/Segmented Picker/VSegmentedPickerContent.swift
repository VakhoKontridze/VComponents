//
//  VSegmentedPickerContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/3/22.
//

import SwiftUI

// MARK: - V Segmented Picker Content
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VSegmentedPickerContent<Element, Content>
    where
        Element: Hashable,
        Content: View
{
    case title(title: (Element) -> String)
    case content(content: (VSegmentedPickerRowInternalState, Element) -> Content)
}
