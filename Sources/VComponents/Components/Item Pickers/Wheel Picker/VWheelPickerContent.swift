//
//  VWheelPickerContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/7/22.
//

import SwiftUI

// MARK: - V Wheel Picker Content
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VWheelPickerContent<SelectionValue, Content>
    where
        SelectionValue: Hashable,
        Content: View
{
    case title(title: (SelectionValue) -> String)
    case content(content: (VWheelPickerInternalState, SelectionValue) -> Content)
}
