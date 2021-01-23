//
//  VLazyListModelHorizontal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Model Horizontal
/// Model that describes UI
public struct VLazyListModelHorizontal {
    public var layout: Layout = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VLazyListModelHorizontal {
    public struct Layout {
        public var spacing: CGFloat = 0
        public var alignment: VerticalAlignment = .center
        
        public init() {}
    }
}

// MARK:- Misc
extension VLazyListModelHorizontal {
    public struct Misc {
        public var showIndicator: Bool = true
        
        init() {}
    }
}
