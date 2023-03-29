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
enum VSegmentedPickerContent<Data, Content>
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        Content: View
{
    // MARK: Properties
    case titles(titles: [String])
    case content(data: Data, content: (VSegmentedPickerRowInternalState, Data.Element) -> Content)
    
    // MARK: Properties
    var count: Int {
        switch self {
        case .titles(let titles): return titles.count
        case .content(let data, _): return data.count
        }
    }
}
