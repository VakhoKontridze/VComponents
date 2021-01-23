//
//  VLazyListModelVertical.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Lazy List Model Vertical
/// Model that describes UI
public struct VLazyListModelVertical {
    public var layout: Layout = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VLazyListModelVertical {
    public struct Layout {
        public var spacing: CGFloat = 0
        public var alignment: HorizontalAlignment = .center
        
        public init() {}
    }
}

// MARK:- Misc
extension VLazyListModelVertical {
    public struct Misc {
        public var showIndicator: Bool = true
        
        init() {}
    }
}
