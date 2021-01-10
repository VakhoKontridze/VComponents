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
    public var showIndicator: Bool = true
    
    var tableModel: VGenericListContentModel {
        var model: VGenericListContentModel = .init()
        
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
    public typealias Colors = VSectionModel.Colors
}
