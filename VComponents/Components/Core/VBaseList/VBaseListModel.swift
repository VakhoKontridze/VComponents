//
//  VGenericListContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Base List Model
/// Model that describes UI
public struct VBaseListModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VBaseListModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Trailing margin. Defaults to `0`.
        ///
        /// Purpose of this property is to create a spacing between rows and scrolling indicator.
        public var marginTrailing: CGFloat = 0
        
        /// Spacing between rows. Defaults to `18`.
        public var rowSpacing: CGFloat = 18
        
        /// Row divider height. Defaults to `1`.
        public var dividerHeight: CGFloat = 1
        
        var hasDivider: Bool { dividerHeight > 0 }
        
        var dividerMarginVertical: CGFloat { rowSpacing / 2 }
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VBaseListModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Divider color
        public var divider: Color = .init(componentAsset: "BaseList.Divider")
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VBaseListModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Sub-Models
extension VBaseListModel {
    var lazyListSubModel: VLazyListModelVertical {
        var model: VLazyListModelVertical = .init()
        model.misc.showIndicator = misc.showIndicator
        return model
    }
}
