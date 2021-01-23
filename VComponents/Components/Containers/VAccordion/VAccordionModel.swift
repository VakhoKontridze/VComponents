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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VAccordionModel {
    public struct Layout {
        public var cornerRadius: CGFloat = sectionReference.layout.cornerRadius
        
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
        
        public var chevronButtonDimension: CGFloat = chevronButtonReference.layout.dimension
        public var chevronButtonIconDimension: CGFloat = chevronButtonReference.layout.iconDimension
        
        public var dividerHeight: CGFloat = sectionReference.layout.dividerHeight
        
        public var itemSpacing: CGFloat = sectionReference.layout.itemSpacing
        
        public init() {}
    }
}

// MARK:- Colors
extension VAccordionModel {
    public struct Colors {
        static let defaultHeader: Color = ColorBook.primary
        
        public var background: Color = sectionReference.colors.background
        
        public var header: StateOpacity = .init(
            disabledOpacity: 0.5
        )
        
        public var headerDivider: Color = .init(componentAsset: "Accordion.Divider")
        
        public var chevronButtonBackground: StateColors = chevronButtonReference.colors.background
        
        public var chevronButtonIcon: StateColorsAndOpacity = chevronButtonReference.colors.content
        
        public var divider: Color = sectionReference.colors.divider
        
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

// MARK:- Fonts
extension VAccordionModel {
    struct Fonts {
        static let header: Font = .system(size: 15, weight: .semibold, design: .default)
    }
}

// MARK:- Misc
extension VAccordionModel {
    public struct Misc {
        public var showIndicator: Bool = true
        public var expandCollapseOnHeaderTap: Bool = true
        
        public init() {}
    }
}

// MARK:- References
extension VAccordionModel {
    public static let sectionReference: VSectionModel = .init()
    public static let chevronButtonReference: VChevronButtonModel = .init()
}

// MARK:- Sub-Models
extension VAccordionModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.marginTrailing = layout.marginTrailing + layout.contentMarginTrailing
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
    
    var chevronButonSubModel: VChevronButtonModel {
        var model: VChevronButtonModel = .init()
        
        model.layout.dimension = layout.chevronButtonDimension
        model.layout.iconDimension = layout.chevronButtonIconDimension
        model.layout.hitBoxHor = 0
        model.layout.hitBoxVer = 0
        
        model.colors.background = colors.chevronButtonBackground
        model.colors.content = colors.chevronButtonIcon
        
        return model
    }
}
