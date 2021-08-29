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
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties
    public var misc: Misc = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VAccordionModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Accordion corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = listReference.layout.cornerRadius
        
        /// Chevron button dimension. Default to `32`.
        public var chevronButtonDimension: CGFloat = chevronButtonReference.layout.dimension
        
        /// Chevron button icon dimension. Default to `12`.
        public var chevronButtonIconDimension: CGFloat = chevronButtonReference.layout.iconDimension
        
        /// Header divider height. Defaults to `1`.
        public var headerDividerHeight: CGFloat = 1
        
        var hasHeaderDivider: Bool { headerDividerHeight > 0 }
        
        /// Header margins. Defaults to `10` leading, `10` trailing, `5` top, `5` bottom when collapsed, and `5` bottom when expanded.
        public var headerMargins: ExpandableMargins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: 10,
            bottomCollapsed: 10,
            bottomExpanded: 5
        )
        
        /// Divider margins. Defaults to `10` leading, `10` trailing, `5` top, and `5` bottom.
        public var headerDividerMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin,
            trailing: sheetReference.layout.contentMargin,
            top: 5,
            bottom: 5
        )
        
        /// Divider margins. Defaults to `15` leading, `15` trailing, `5` top, and `15` bottom.
        public var contentMargins: Margins = .init(
            leading: sheetReference.layout.contentMargin + 5,
            trailing: sheetReference.layout.contentMargin + 5,
            top: 5,
            bottom: sheetReference.layout.contentMargin + 5
        )
        
        /// Row spacing. Defaults to `18`.
        public var rowSpacing: CGFloat = listReference.layout.rowSpacing
        
        /// Row divider height. Defaults to `1`.
        public var dividerHeight: CGFloat = listReference.layout.dividerHeight
        
        /// Divider margins. Defaults to `0` leading and `0` trailing.
        public var dividerMargins: HorizontalMargins = listReference.layout.dividerMargins
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VAccordionModel.Layout {
    /// Sub-model containing `leading` and `trailing` margins
    public typealias HorizontalMargins = VBaseListModel.Layout.HorizontalMargins
    
    /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins
    public typealias Margins = LayoutGroup_LTTB
    
    /// Sub-model containing `leading`, `trailing`, `top` and `bottom collapsed` and `bottom expanded` margins
    public struct ExpandableMargins {
        /// Leading margin
        public var leading: CGFloat
        
        /// Trailing margin
        public var trailing: CGFloat
        
        /// Top margin
        public var top: CGFloat
        
        /// Bottom collapsed margin
        public var bottomCollapsed: CGFloat
        
        /// Bottom expanded margin
        public var bottomExpanded: CGFloat
        
        /// Initializes sub-model with margins
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
    /// Sub-model containing color properties
    public struct Colors {
        /// Background color
        public var background: Color = listReference.colors.background
        
        /// Header state opacities
        public var header: StateOpacities = .init(
            disabledOpacity: 0.5
        )
        
        /// Text header color
        ///
        /// Only applicable when using init with title
        public var headerText: Color = ColorBook.primary
        
        /// Header divider color
        public var headerDivider: Color = .init(componentAsset: "Accordion.Divider")
        
        /// Chevron button background colors
        public var chevronButtonBackground: StateColors = chevronButtonReference.colors.background
        
        /// Chevron button icon colors and opacities
        public var chevronButtonIcon: StateColorsAndOpacities = chevronButtonReference.colors.content
        
        /// Row divider color
        public var divider: Color = listReference.colors.divider
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VAccordionModel.Colors {
    /// Sub-model containing opacities for component states
    public typealias StateOpacities = StateOpacities_D
    
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColors_EPD
    
    /// Sub-model containing colors and opacities for component states
    public typealias StateColorsAndOpacities = StateColorsAndOpacities_EPD_PD
}

// MARK:- Fonts
extension VAccordionModel {
    /// Sub-model containing font properties
    public struct Fonts {
        /// Header font
        ///
        /// Only applicable when using init with title
        public var header: Font = .system(size: 17, weight: .bold)
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Animations
extension VAccordionModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// Expand and collapse animation. Defaults to `default`.
        public var expandCollapse: Animation? = .default
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Misc
extension VAccordionModel {
    /// Sub-model containing misc properties
    public struct Misc {
        /// Indicates if scrolling indicator is shown. Defaults to `true`.
        public var showIndicator: Bool = true
        
        /// Indicates if accordion should expand or collapse from tap on header. Default to `true`.
        public var expandCollapseOnHeaderTap: Bool = true
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VAccordionModel {
    /// Reference to `VSheetModel`
    public static let sheetReference: VSheetModel = .init()
    
    /// Reference to `VListModel`
    public static let listReference: VListModel = .init()
    
    /// Reference to `VChevronButtonModel`
    public static let chevronButtonReference: VChevronButtonModel = .init()
}

// MARK:- Sub-Models
extension VAccordionModel {
    var baseListSubModel: VBaseListModel {
        var model: VBaseListModel = .init()
        
        model.misc.showIndicator = misc.showIndicator
        
        model.layout.marginTrailing = layout.contentMargins.trailing
        model.layout.rowSpacing = layout.rowSpacing
        model.layout.dividerHeight = layout.dividerHeight
        model.layout.dividerMargins = layout.dividerMargins
        
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
        model.layout.hitBox.horizontal = 0
        model.layout.hitBox.vertical = 0
        
        model.colors.background = colors.chevronButtonBackground
        model.colors.content = colors.chevronButtonIcon
        
        return model
    }
}
