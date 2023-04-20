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
    // MARK: Properties
    case title(data: [SelectionValue], title: (SelectionValue) -> String)
    case content(data: [SelectionValue], content: (VWheelPickerInternalState, SelectionValue) -> Content)
    
    // MARK: Array API
    var count: Int {
        switch self {
        case .title(let data, _): return data.count
        case .content(let data, _): return data.count
        }
    }
}
