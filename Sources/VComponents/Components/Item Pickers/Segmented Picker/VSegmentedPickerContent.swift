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
    // MARK: Properties
    case title(data: [SelectionValue], title: (SelectionValue) -> String)
    case content(data: [SelectionValue], content: (VSegmentedPickerRowInternalState, SelectionValue) -> Content)
    
    // MARK: Array API
    var count: Int {
        switch self {
        case .title(let data, _): return data.count
        case .content(let data, _): return data.count
        }
    }

    var indices: Range<Int> {
        switch self {
        case .title(let data, _): return data.indices
        case .content(let data, _): return data.indices
        }
    }

    func firstIndex(of element: SelectionValue) -> Int {
        switch self {
        case .title(let data, _): return data.firstIndex(of: element)! // Force-unwrap
        case .content(let data, _): return data.firstIndex(of: element)! // Force-unwrap
        }
    }
}
