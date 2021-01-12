//
//  VTableModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Model
public struct VTableModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    static let defaultHeaderFooterFont: Font = .system(size: 13, weight: .regular, design: .default)
    public var showIndicator: Bool = true
    
    var genericListContentModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.showIndicator = showIndicator
        
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
extension VTableModel {
    public struct Layout {
        public static let sectionLayout: VSectionModel.Layout = .init()
        
        public var cornerRadius: CGFloat = sectionLayout.cornerRadius
        public var contentMargin: CGFloat = sectionLayout.contentMargin
        
        public var headerMarginBottom: CGFloat = 10
        public var itemSpacing: CGFloat = sectionLayout.itemSpacing
        public var footerMarginTop: CGFloat = 10
        public var sectionSpacing: CGFloat = 20
        
        public var separatorHeight: CGFloat = sectionLayout.separatorHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VTableModel {
    public struct Colors {
        public static let sectionColors: VSectionModel.Colors = .init()
        
        static let defaultHeaderFooter: Color = ColorBook.secondary
        public var separator: Color = sectionColors.separator
        public var background: Color = sectionColors.background
        
        public init() {}
    }
}
