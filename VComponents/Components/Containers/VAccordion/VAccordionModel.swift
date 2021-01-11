//
//  VAccordionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion Model
public struct VAccordionModel {
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    static let defaultHeaderFont: Font = .system(size: 15, weight: .semibold, design: .default)
    public var showIndicator: Bool = true
    
    var genericListContentModel: VGenericListContentModel {
        var model: VGenericListContentModel = .init()
        
        model.showIndicator = showIndicator
        
        model.layout.marginTrailing = layout.marginTrailing + layout.contentMarginTrailing
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
extension VAccordionModel {
    public struct Layout {
        public static let sectionLayout: VSectionModel.Layout = .init()
        
        public var cornerRadius: CGFloat = sectionLayout.cornerRadius
        
        public var marginLeading: CGFloat = 16
        public var marginTrailing: CGFloat = 16
        public var marginTop: CGFloat = 8
        public var marginBottomCollapsed: CGFloat = 8
        public var marginBottomExpanded: CGFloat = 16
        
        public var headerSeparatorHeight: CGFloat = 1
        public var headerSeparatorMarginTop: CGFloat = 8
        public var headerSeparatorMarginBottom: CGFloat = 10
        
        public var contentMarginLeading: CGFloat = 5
        public var contentMarginTrailing: CGFloat = 5
        public var contentMarginTop: CGFloat = 0
        public var contentMarginBottom: CGFloat = 5
        
        public var separatorHeight: CGFloat = sectionLayout.separatorHeight
        
        public var itemSpacing: CGFloat = sectionLayout.itemSpacing
        
        public init() {}
    }
}

// MARK:- Colors
extension VAccordionModel {
    public struct Colors {
        public static let sectionColors: VSectionModel.Colors = .init()
        
        static let defaultHeader: Color = ColorBook.primary
        
        public var headerDisabledOpacity: Double = 0.5
        public var headerSeparator: Color = .init(componentAsset: "Accordion.Separator")
        public var separator: Color = sectionColors.separator
        public var background: Color = sectionColors.background
        
        public init() {}
    }
}

// MARK:- VM
extension VAccordionModel {
    func headerOpacity(for state: VAccordionState) -> Double {
        switch state {
        case .collapsed: return 1
        case .expanded: return 1
        case .disabled: return colors.headerDisabledOpacity
        }
    }
}
