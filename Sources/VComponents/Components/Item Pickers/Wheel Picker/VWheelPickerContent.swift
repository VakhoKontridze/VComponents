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
enum VWheelPickerContent<Data, Content>
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    case titles(titles: [String])
    case content(data: Data, content: (VWheelPickerInternalState, Data.Element) -> Content)
    
    // MARK: Properties
    var count: Int {
        switch self {
        case .titles(let titles): return titles.count
        case .content(let data, _): return data.count
        }
    }
}

