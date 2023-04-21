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
enum VSegmentedPickerContent<SelectionValue, Content>
    where
        SelectionValue: Hashable,
        Content: View
{
    case title(title: (SelectionValue) -> String)
    case content(content: (VSegmentedPickerRowInternalState, SelectionValue) -> Content)
}
