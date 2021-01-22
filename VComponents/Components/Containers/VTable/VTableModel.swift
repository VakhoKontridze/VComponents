//
//  VTableModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK:- V Table Model
/// Model that describes UI
public struct VTableModel {
    public static let sectionModel: VSectionModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    static let defaultHeaderFooterFont: Font = .system(size: 13, weight: .regular, design: .default)
    public var showIndicator: Bool = true
    
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.showIndicator = showIndicator
        
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.dividerHeight = layout.dividerHeight
        
        model.colors.divider = colors.divider
        
        return model
    }
    
    var sheetSubModel: VSheetModel {
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
        public var cornerRadius: CGFloat = VTableModel.sectionModel.layout.cornerRadius
        public var contentMargin: CGFloat = VTableModel.sectionModel.layout.contentMargin
        
        public var headerMarginBottom: CGFloat = 10
        public var itemSpacing: CGFloat = VTableModel.sectionModel.layout.itemSpacing
        public var footerMarginTop: CGFloat = 10
        public var sectionSpacing: CGFloat = 20
        
        public var dividerHeight: CGFloat = VTableModel.sectionModel.layout.dividerHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VTableModel {
    public struct Colors {
        static let defaultHeaderFooter: Color = ColorBook.secondary
        public var divider: Color = VTableModel.sectionModel.colors.divider
        public var background: Color = VTableModel.sectionModel.colors.background
        
        public init() {}
    }
}
