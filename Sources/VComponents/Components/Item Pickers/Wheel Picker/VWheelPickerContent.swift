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
enum VWheelPickerContent<Element, Content>
    where
        Element: Hashable,
        Content: View
{
    case title(title: (Element) -> String)
    case content(content: (VWheelPickerInternalState, Element) -> Content)
}
