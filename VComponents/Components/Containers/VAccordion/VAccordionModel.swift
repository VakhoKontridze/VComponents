//
//  VAccordionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK:- V Accordion Model
/// Model that describes UI
public struct VAccordionModel {
    public static let sectionModel: VSectionModel = .init()
    public static let chevronButtonModel: VChevronButtonModel = .init()
    
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    static let defaultHeaderFont: Font = .system(size: 15, weight: .semibold, design: .default)
    public var showIndicator: Bool = true
    public var expandCollapseOnHeaderTap: Bool = true
    
    var genericListContentModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.showIndicator = showIndicator
        
        model.layout.marginTrailing = layout.marginTrailing + layout.contentMarginTrailing
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.dividerHeight = layout.dividerHeight
        
        model.colors.divider = colors.divider
        
        return model
    }
    
    var sheetModel: VSheetModel {
        var model: VSheetModel = .init()
        
        model.layout.cornerRadius = layout.cornerRadius
        model.layout.contentMargin = 0
        
        model.color = colors.background
        
        return model
    }
    
    var chevronButonModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.chevronButtonDimension
        model.layout.iconDimension = layout.chevronButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = colors.chevronButtonBackground
        model.colors.content = colors.chevronButtonIcon
        
        return model
    }
    
    public init() {}
}

// MARK:- Layout
extension VAccordionModel {
    public struct Layout {
        public var cornerRadius: CGFloat = VAccordionModel.sectionModel.layout.cornerRadius
        
        public var marginLeading: CGFloat = 15
        public var marginTrailing: CGFloat = 15
        public var marginTop: CGFloat = 8
        public var marginBottomCollapsed: CGFloat = 8
        public var marginBottomExpanded: CGFloat = 15
        
        public var headerDividerHeight: CGFloat = 1
        public var headerDividerMarginTop: CGFloat = 8
        public var headerDividerMarginBottom: CGFloat = 10
        
        public var contentMarginLeading: CGFloat = 5
        public var contentMarginTrailing: CGFloat = 5
        public var contentMarginTop: CGFloat = 0
        public var contentMarginBottom: CGFloat = 5
        
        public var chevronButtonDimension: CGFloat = VAccordionModel.chevronButtonModel.layout.dimension
        public var chevronButtonIconDimension: CGFloat = VAccordionModel.chevronButtonModel.layout.iconDimension
        
        public var dividerHeight: CGFloat = VAccordionModel.sectionModel.layout.dividerHeight
        
        public var itemSpacing: CGFloat = VAccordionModel.sectionModel.layout.itemSpacing
        
        public init() {}
    }
}

// MARK:- Colors
extension VAccordionModel {
    public struct Colors {
        static let defaultHeader: Color = ColorBook.primary
        
        public var background: Color = VAccordionModel.sectionModel.colors.background
        
        public var header: StateOpacity = .init(
            disabledOpacity: 0.5
        )
        
        public var headerDivider: Color = .init(componentAsset: "Accordion.Divider")
        
        public var chevronButtonBackground: StateColors = VAccordionModel.chevronButtonModel.colors.background
        
        public var chevronButtonIcon: StateColorsAndOpacity = VAccordionModel.chevronButtonModel.colors.content
        
        public var divider: Color = VAccordionModel.sectionModel.colors.divider
        
        public init() {}
    }
}

extension VAccordionModel.Colors {
    public struct StateOpacity {
        public var disabledOpacity: Double
        
        public init(disabledOpacity: Double) {
            self.disabledOpacity = disabledOpacity
        }
        
        func `for`(_ state: VAccordionState) -> Double {
            switch state {
            case .collapsed: return 1
            case .expanded: return 1
            case .disabled: return disabledOpacity
            }
        }
    }
    
    public typealias StateColors = VChevronButtonModel.Colors.StateColors
    
    public typealias StateColorsAndOpacity = VChevronButtonModel.Colors.StateColorsAndOpacity
}
