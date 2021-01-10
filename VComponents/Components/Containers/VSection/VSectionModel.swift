//
//  VSectionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section Model
public struct VSectionModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var showIndicator: Bool = true
    
    var tableModel: VGenericListContentModel {
        var model: VGenericListContentModel = .init()
        
        model.showIndicator = showIndicator
        
        model.layout.marginTrailing = layout.contentPadding
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.separatorHeight = layout.separatorHeight
        
        model.colors.separator = colors.separator
        
        return model
    }
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentPadding = 0
        
        model.color = colors.background
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VSectionModel {
    public struct Layout {
        public static let genericListContentLayout: VGenericListContentModel.Layout = .init()
        public static let sheetLayout: VSheetModel.Layout = .init()
        
        public var cornerRadius: CGFloat = sheetLayout.cornerRadius
        public var contentPadding: CGFloat = sheetLayout.contentPadding
        public var itemSpacing: CGFloat = genericListContentLayout.itemSpacing
        public var separatorHeight: CGFloat = genericListContentLayout.separatorHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VSectionModel {
    public struct Colors {
        public static let genericListContentColors: VGenericListContentModel.Colors = .init()
        public static let sheetColor: Color = VSheetModel().color
        
        public var background: Color = sheetColor
        public var separator: Color = genericListContentColors.separator
        
        public init() {}
    }
}
