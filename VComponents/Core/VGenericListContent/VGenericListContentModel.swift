//
//  VGenericListContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Generic List Content Model
public struct VGenericListContentModel {
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
extension VGenericListContentModel {
    public struct Layout {
        public var marginTrailing: CGFloat = 0
        
        public var itemSpacing: CGFloat = 18
        
        public var separatorHeight: CGFloat = 1
        public var hasSeparator: Bool { separatorHeight > 0 }
        public var separatorMarginVer: CGFloat { itemSpacing / 2 }
        
        init() {}
    }
}

// MARK:- Colors
extension VGenericListContentModel {
    public struct Colors {
        public var separator: Color = .init(componentAsset: "GenericListContent.Separator")
        
        init() {}
    }
}
