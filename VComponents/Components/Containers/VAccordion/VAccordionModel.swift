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
    public var fonts: Fonts = .init()
    public var animations: Animations = .init()
    public var misc: Misc = .init()
    
    public init() {}
}

// MARK:- Layout
extension VAccordionModel {
    public struct Layout {
        public var cornerRadius: CGFloat = sectionReference.layout.cornerRadius
        
        public var chevronButtonDimension: CGFloat = chevronButtonReference.layout.dimension
        public var chevronButtonIconDimension: CGFloat = chevronButtonReference.layout.iconDimension
        
        public var dividerHeight: CGFloat = 1
        var hasDivider: Bool { dividerHeight > 0 }
        
        public var rowDividerHeight: CGFloat = sectionReference.layout.dividerHeight
        
        public var headerMargin: ExpandableMargins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: 12,
            bottomCollapsed: 12,
            bottomExpanded: 12/2
        )
        
        public var dividerMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: 12/2,
            bottom: 12/2
        )
        
        public var contentMargin: Margins = .init(
            leading: sheetReference.layout.contentMargin + 5,
            trailing: sheetReference.layout.contentMargin + 5,
            top: 12/2,
            bottom: sheetReference.layout.contentMargin + 5
        )
        
        public var itemSpacing: CGFloat = sectionReference.layout.itemSpacing
        
        public init() {}
    }
}

extension VAccordionModel.Layout {
    public typealias Margins = VModalModel.Layout.Margins
    
    public struct ExpandableMargins {
        public var leading: CGFloat
        public var trailing: CGFloat
        public var top: CGFloat
        public var bottomCollapsed: CGFloat
        public var bottomExpanded: CGFloat
        
        public init(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottomCollapsed: CGFloat, bottomExpanded: CGFloat) {
            self.leading = leading
            self.trailing = trailing
            self.top = top
            self.bottomCollapsed = bottomCollapsed
            self.bottomExpanded = bottomExpanded
        }
    }
}

// MARK:- Colors
extension VAccordionModel {
    public struct Colors {
        public var background: Color = sectionReference.colors.background
        
        public var header: StateOpacity = .init(
            disabledOpacity: 0.5
        )
        
        public var headerText: Color = ColorBook.primary    // Only applicable during init with title
        
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
    public struct Fonts {
        public var header: Font = .system(size: 17, weight: .bold, design: .default)    // Only applicable during init with title
        
        public init() {}
    }
}

// MARK:- Animations
extension VAccordionModel {
    public struct Animations {
        public var expandCollapse: Animation? = .default
        
        public init() {}
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
    public static let sheetReference: VSheetModel = .init()
    public static let sectionReference: VSectionModel = .init()
    public static let chevronButtonReference: VChevronButtonModel = .init()
}

// MARK:- Sub-Models
extension VAccordionModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.marginTrailing = layout.contentMargin.trailing
        model.layout.itemSpacing = layout.itemSpacing
        model.layout.dividerHeight = layout.rowDividerHeight
        
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
