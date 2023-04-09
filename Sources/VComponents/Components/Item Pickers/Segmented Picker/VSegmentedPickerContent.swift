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
    case title(data: Data, title: (Data.Element) -> String)
    case content(data: Data, content: (VSegmentedPickerRowInternalState, Data.Element) -> Content)
    
    // MARK: Properties
    var count: Int {
        switch self {
        case .title(let data, _): return data.count
        case .content(let data, _): return data.count
        }
    }
}
