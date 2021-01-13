//
//  VGenericListContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Base List Model
public struct VBaseListModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var showIndicator: Bool = true
    
    var lazyListModel: VLazyListModelVertical {
        var model: VLazyListModelVertical = .init()
        model.showIndicator = showIndicator
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VBaseListModel {
    public struct Layout {
        public var marginTrailing: CGFloat = 0
        
        public var itemSpacing: CGFloat = 18
        
        public var dividerHeight: CGFloat = 1
        public var hasDivider: Bool { dividerHeight > 0 }
        public var dividerMarginVer: CGFloat { itemSpacing / 2 }
        
        init() {}
    }
}

// MARK:- Colors
extension VBaseListModel {
    public struct Colors {
        public var divider: Color = .init(componentAsset: "GenericListContent.Divider")
        
        init() {}
    }
}
