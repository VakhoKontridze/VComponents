//
//  VLazyListModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Lazy List Model
public struct VLazyListModel {
    // MARK: Properties
    public let scrollDirection: VLazyListScrollDirection
    public let showsIndicators: Bool
    
    // MARK: Iniitalizers
    public init(scrollDirection: VLazyListScrollDirection, showsIndicators: Bool) {
        self.scrollDirection = scrollDirection
        self.showsIndicators = showsIndicators
    }
    
    public init() {
        self.init(
            scrollDirection: .vertical(alignment: .center),
            showsIndicators: true
        )
    }
}

// MARK:- V Lazy List Scrolling Direction
public enum VLazyListScrollDirection {
    case vertical(alignment: HorizontalAlignment)
    case horizontal(aligment: VerticalAlignment)
}
