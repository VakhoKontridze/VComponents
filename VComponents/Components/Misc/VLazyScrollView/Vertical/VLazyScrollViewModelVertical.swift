//
//  VLazyScrollViewModelVertical.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Lazy Scroll View Model Vertical
/// Model that describes UI
public struct VLazyScrollViewModelVertical {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK: - Layout
extension VLazyScrollViewModelVertical {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Row spacing. Defaults to `0`.
        public var rowSpacing: CGFloat = 0
        
        /// Row alignment. Defaults to .`center`.
        public var alignment: HorizontalAlignment = .center
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK: - Misc
extension VLazyScrollViewModelVertical {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}
