//
//  VLazyListModelHorizontal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Model Horizontal
public struct VLazyListModelHorizontal {
    public let layout: Layout
    
    public init(
        layout: Layout = .init()
    ) {
        self.layout = layout
    }
}

// MARK:- Layout
extension VLazyListModelHorizontal {
    public struct Layout {
        public let alignment: VerticalAlignment
        public let showsIndicators: Bool
        
        public init(
            alignment: VerticalAlignment = .center,
            showsIndicators: Bool = true
        ) {
            self.alignment = alignment
            self.showsIndicators = showsIndicators
        }
    }
}

