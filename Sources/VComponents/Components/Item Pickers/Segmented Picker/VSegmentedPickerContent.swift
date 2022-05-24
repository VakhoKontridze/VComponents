//
//  VSegmentedPickerContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/3/22.
//

import SwiftUI

// MARK: - V Segmented Picker Content
enum VSegmentedPickerContent<Data, CustomContent>
    where
        Data: RandomAccessCollection,
        Data.Index == Int,
        CustomContent: View
{
    // MARK: Properties
    case titles(titles: [String])
    case custom(data: Data, content: (Data.Element) -> CustomContent)
    
    // MARK: Properties
    var count: Int {
        switch self {
        case .titles(let titles): return titles.count
        case .custom(let data, _): return data.count
        }
    }
}
