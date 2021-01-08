//
//  VLazyListModelHorizontal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Model Horizontal
public struct VLazyListModelHorizontal {
    public var layout: Layout = .init()
    
    public init() {}
}

// MARK:- Layout
extension VLazyListModelHorizontal {
    public struct Layout {
        public var alignment: VerticalAlignment = .center
        public var showsIndicators: Bool = true
        
        public init() {}
    }
}

