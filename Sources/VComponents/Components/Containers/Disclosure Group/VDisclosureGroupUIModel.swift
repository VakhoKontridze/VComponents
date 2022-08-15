//
//  VDisclosureGroupUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group UI Model
/// Model that describes UI.
public struct VDisclosureGroupUIModel {
    // MARK: Properties
    fileprivate static let sheetReference: VSheetUIModel = .init()
    fileprivate static let chevronButtonReference: VChevronButtonUIModel = .init()
    fileprivate static let listReference: VListUIModel = .init()
    
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
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Disclosure group corner radius. Defaults to `15`.
        public var cornerRadius: CGFloat = 15
        
        /// Header margins. Defaults to `15` horizontal and  `10` vertical.
        public var headerMargins: Margins = .init(
            horizontal: sheetReference.layout.contentMargin,
            vertical: 10
        )
        
        /// Chevron button dimension. Defaults to `30`.
        public var chevronButtonDimension: CGFloat = chevronButtonReference.layout.dimension
        
        /// Chevron button icon dimension. Defaults to `12`.
        public var chevronButtonIconDimension: CGFloat = chevronButtonReference.layout.iconDimension
        
        /// Divider height. Defaults to `2` scaled to screen.
        ///
        /// To hide divider, set to `0`.
        public var dividerHeight: CGFloat = CGFloat(2) / UIScreen.main.scale
        
        /// Divider margins .Defaults to `15` horizontal and  `0` vertical.
        public var dividerMargins: Margins = .init(
            horizontal: sheetReference.layout.contentMargin,
            vertical: 0
        )
        
        /// Content margins. Defaults to `zero`.
        public var contentMargins: Margins = .zero
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: Margins
        /// Sub-model containing `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
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
        /// When using a custom header label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customHeaderLabelOpacities: StateOpacities = .init(
            collapsed: 1,
            expanded: 1,
            disabled: 0.5
        )
        
        /// Divider color.
        public var divider: Color = listReference.colors.separator
        
        /// Chevron button background colors.
        public var chevronButtonBackground: ButtonStateColors = chevronButtonReference.colors.background
        
        /// Chevron button icon colors.
        public var chevronButtonIcon: ButtonStateColors = chevronButtonReference.colors.icon
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Sub-model containing colors for component states.
        public typealias StateColors = GenericStateModel_CollapsedExpandedDisabled<Color>
        
        // MARK: State Opacities
        /// Sub-model containing opacities for component states.
        public typealias StateOpacities = GenericStateModel_CollapsedExpandedDisabled<CGFloat>
        
        // MARK: Button State Colors
        /// Sub-model containing colors for component states.
        public typealias ButtonStateColors = GenericStateModel_EnabledPressedDisabled<Color>
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
        /// Indicates if disclosure group expands and collapses from header tap. Defaults to `true`.
        public var expandsAndCollapsesOnHeaderTap: Bool = true
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }

    // MARK: Sub-Models
    var plainDisclosureGroupSubUIModel: PlainDisclosureGroupUIModel {
        var uiModel: PlainDisclosureGroupUIModel = .init()
        
        uiModel.colors.background = colors.background
        
        uiModel.animations.expandCollapse = animations.expandCollapse
        
        return uiModel
    }
    
    var sheetSubUIModel: VSheetUIModel {
        var uiModel: VSheetUIModel = .init()
        
        uiModel.layout.cornerRadius = uiModel.layout.cornerRadius
        uiModel.layout.contentMargin = 0
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var chevronButtonSubUIModel: VChevronButtonUIModel {
        var uiModel: VChevronButtonUIModel = .init()
        
        uiModel.layout.dimension = layout.chevronButtonDimension
        uiModel.layout.iconDimension = layout.chevronButtonIconDimension
        uiModel.layout.hitBox.horizontal = 0
        uiModel.layout.hitBox.vertical = 0
        
        uiModel.colors.background = colors.chevronButtonBackground
        uiModel.colors.icon = colors.chevronButtonIcon
        
        return uiModel
    }
}

// MARK: - Factory
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` that insets content.
    public var insettedContent: VDisclosureGroupUIModel {
        var uiModel: VDisclosureGroupUIModel = .init()
        
        uiModel.layout.contentMargins = .init(VSheetUIModel.Layout().contentMargin)
        
        return uiModel
    }
}
