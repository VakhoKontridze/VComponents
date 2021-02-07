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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var fonts: Fonts = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VTableModel {
    public struct Layout {
        public var cornerRadius: CGFloat = sectionReference.layout.cornerRadius
        public var contentMargin: CGFloat = sectionReference.layout.contentMargin
        
        public var sectionSpacing: CGFloat = 20
        public var itemSpacing: CGFloat = sectionReference.layout.itemSpacing
        
        public var headerMarginBottom: CGFloat = 10
        public var footerMarginTop: CGFloat = 10
        
        public var dividerHeight: CGFloat = sectionReference.layout.dividerHeight
        
        public init() {}
    }
}

// MARK:- Colors
extension VTableModel {
    public struct Colors {
        public var divider: Color = sectionReference.colors.divider
        public var background: Color = sectionReference.colors.background
        
        public var headerText: Color = ColorBook.secondary  // Only applicable during init with title
        public var footerText: Color = ColorBook.secondary  // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Fonts
extension VTableModel {
    public struct Fonts {
        public var header: Font = .system(size: 13)   // Only applicable during init with title
        public var footer: Font = .system(size: 13)   // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Misc
extension VTableModel {
    public struct Misc {
        public var showIndicator: Bool = true
        
        public init() {}
    }
}

// MARK:- References
extension VTableModel {
    public static let sectionReference: VSectionModel = .init()
}

// MARK:- Sub-Models
extension VTableModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
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
}
