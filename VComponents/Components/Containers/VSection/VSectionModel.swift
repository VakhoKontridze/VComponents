//
//  VSectionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Section Model
/// Model that describes UI
public struct VSectionModel {
    public static let baseListModel: VBaseListModel = .init()
    public static let sheetModel: VSheetModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var misc: Misc = .init()
    
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.marginTrailing = layout.contentMargin
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.dividerHeight = layout.dividerHeight
        
        model.colors.divider = colors.divider
        
        return model
    }
    
    var sheetSubModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.colors.background = colors.background
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VSectionModel {
    public struct Layout {
        public var titleMarginHor: CGFloat = 0
        public var titleMarginBottom: CGFloat = 10
        
        public var cornerRadius: CGFloat = VSectionModel.sheetModel.layout.cornerRadius
        public var contentMargin: CGFloat = VSectionModel.sheetModel.layout.contentMargin
        public var itemSpacing: CGFloat = VSectionModel.baseListModel.layout.itemSpacing
        public var dividerHeight: CGFloat = VSectionModel.baseListModel.layout.dividerHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VSectionModel {
    public struct Colors {
        public var title: Color = ColorBook.primary
        public var divider: Color = VSectionModel.baseListModel.colors.divider
        public var background: Color = VSectionModel.sheetModel.colors.background
        
        public init() {}
    }
}

// MARK:- Fonts
extension VSectionModel {
    public struct Fonts {
        public var title: Font = .system(size: 14, weight: .bold, design: .default)
        
        public init() {}
    }
}

// MARK:- Misc
extension VSectionModel {
    public struct Misc {
        public var showIndicator: Bool = true
        
        public init() {}
    }
}
