//
//  VLazyListHorizontalModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Horizontal Model
public struct VLazyListHorizontalModel {
    public let layout: Layout
    
    public init(
        layout: Layout = .init()
    ) {
        self.layout = layout
    }
}

// MARK:- Layout
extension VLazyListHorizontalModel {
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

