//
//  VAccordionModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI

// MARK: - V Accordion Model
/// Model that describes UI.
public struct VAccordionModel {
    // MARK: Properties
    /// Reference to `VSheetModel`.
    public static let sheetReference: VSheetModel = .init()
    
    /// Reference to `VChevronButtonModel`.
    public static let chevronButtonReference: VChevronButtonModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing font properties.
    public var fonts: Fonts = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    /// Sub-model containing misc properties.
    public var misc: Misc = .init()
    
    // MARK: Initializers
    /// Initializes model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Accordion corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Header margins. Defaults to `15` leading, `15` trailing, `10` top, `10` bottom.
        public var headerMargins: Margins = .init(
            horizontal: sheetReference.layout.contentMargin,
            vertical: 10
        )
        
        /// Chevron button dimension. Default to `32`.
        public var chevronButtonDimension: CGFloat = chevronButtonReference.layout.dimension
        
        /// Chevron button icon dimension. Default to `12`.
        public var chevronButtonIconDimension: CGFloat = chevronButtonReference.layout.iconDimension
        
        /// Header divider height. Defaults to `0.5`.
        public var headerDividerHeight: CGFloat = 0.5
        
        /// Header divider margins. Defaults to `10` leading, `10` trailing, `0` top, `0` bottom.
        public var headerDividerMargins: Margins = .init(
            horizontal: 10,
            vertical: 0
        )
        
        /// Content margins. Defaults to `15` leading, `15` trailing, `15` top, and `15` bottom.
        public var contentMargins: Margins = .init(sheetReference.layout.contentMargin)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LTTB
    }

    // MARK: Colors
    /// Sub-model containing color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = sheetReference.colors.background
        
        /// Header title colors.
        ///
        /// Only applicable when using `init`with title.
        public var headerTitle: StateColors = .init(
            collapsed: ColorBook.primary,
            expanded: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom header label opacities.
        ///
        /// Applicable only when `init`with header label is used.
        /// When using a custom header label, it's subviews cannot be configured with indivudual colors,
        /// so instead, a general opacity is being applied.
        public var customHeaderLabelOpacities: StateOpacities = .init(
            collapsed: 1,
            expanded: 1,
            disabled: 0.5
        )
        
        /// Header divider color.
        public var headerDivider: Color = .init(componentAsset: "Accordion.Divider")
        
        /// Chevron button background colors.
        public var chevronButtonBackground: ButtonStateColors = chevronButtonReference.colors.background
        
        /// Chevron button icon colors.
        public var chevronButtonIcon: ButtonStateColors = chevronButtonReference.colors.icon
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_CED<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_CED<CGFloat>
        
        // MARK: Button State Colors
        /// Sub-model containing colors for component states.
        public typealias ButtonStateColors = GenericStateModel_EPD<Color>
    }

    // MARK: Fonts
    /// Sub-model containing font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header title font.
        ///
        /// Only applicable when using `init`with header.
        public var headerTitle: Font = .system(size: 17, weight: .bold)
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Sub-model containing animation properties.
    public struct Animations {
        // MARK: Properties
        /// Expand and collapse animation. Defaults to `default`.
        public var expandCollapse: Animation? = .default
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Sub-model containing misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if accordion expands and collapses from header tap. Default to `true`.
        public var expandsAndCollapsesOnHeaderTap: Bool = true
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Sub-Models
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
        model.colors.icon = colors.chevronButtonIcon
        
        return model
    }
}
