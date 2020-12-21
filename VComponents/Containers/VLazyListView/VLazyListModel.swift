//
//  VLazyListModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Lazy List Model
public struct VLazyListModel {
    public let scrollDirection: VLazyListScrollDirection
    public let showsIndicators: Bool
    
    public init(
        scrollDirection: VLazyListScrollDirection = .vertical(alignment: .center),
        showsIndicators: Bool = true
    ) {
        self.scrollDirection = scrollDirection
        self.showsIndicators = showsIndicators
    }
}

// MARK:- V Lazy List Scrolling Direction
public enum VLazyListScrollDirection {
    case vertical(alignment: HorizontalAlignment)
    case horizontal(aligment: VerticalAlignment)
}
