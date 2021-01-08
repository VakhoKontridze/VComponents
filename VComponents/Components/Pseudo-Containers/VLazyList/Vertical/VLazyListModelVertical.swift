//
//  VLazyListModelVertical.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Lazy List Model Vertical
public struct VLazyListModelVertical {
    public var layout: Layout = .init()
    
    public init() {}
}

// MARK:- Layout
extension VLazyListModelVertical {
    public struct Layout {
        public let alignment: HorizontalAlignment = .center
        public let showsIndicators: Bool = true
        
        public init() {}
    }
}
