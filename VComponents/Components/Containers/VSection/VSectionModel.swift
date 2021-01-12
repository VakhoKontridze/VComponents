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
    public var titleFont: Font = .system(size: 14, weight: .bold, design: .default)
    public var showIndicator: Bool = true
    
    var genericListContentModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.showIndicator = showIndicator
        
        model.layout.marginTrailing = layout.contentMargin
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.separatorHeight = layout.separatorHeight
        
        model.colors.separator = colors.separator
        
        return model
    }
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.color = colors.background
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VSectionModel {
    public struct Layout {
        public static let genericListContentLayout: VBaseListModel.Layout = .init()
        public static let sheetLayout: VSheetModel.Layout = .init()
        
        public var titleMarginHor: CGFloat = 10
        public var titleMarginBottom: CGFloat = 10
        
        public var cornerRadius: CGFloat = sheetLayout.cornerRadius
        public var contentMargin: CGFloat = sheetLayout.contentMargin
        public var itemSpacing: CGFloat = genericListContentLayout.itemSpacing
        public var separatorHeight: CGFloat = genericListContentLayout.separatorHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VSectionModel {
    public struct Colors {
        public static let genericListContentColors: VBaseListModel.Colors = .init()
        public static let sheetColor: Color = VSheetModel().color
        
        public var title: Color = ColorBook.primary
        public var separator: Color = genericListContentColors.separator
        public var background: Color = sheetColor
        
        public init() {}
    }
}
