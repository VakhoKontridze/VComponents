//
//  VLazyListViewModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- VLazyListViewModel
public struct VLazyListViewModel {
    // MARK: Properties
    public let scrollDirection: ScrollDirection
    public let showsIndicators: Bool
    
    // MARK: Iniitalizers
    public init(scrollDirection: ScrollDirection, showsIndicators: Bool) {
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

public enum ScrollDirection {
    case vertical(alignment: HorizontalAlignment)
    case horizontal(aligment: VerticalAlignment)
}
