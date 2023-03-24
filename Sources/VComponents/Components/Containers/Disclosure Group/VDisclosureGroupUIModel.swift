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
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VDisclosureGroupUIModel {
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains font properties.
    public var fonts: Fonts = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    /// Model that contains misc properties.
    public var misc: Misc = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Disclosure group corner radius. Set to `15`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius
        
        /// Header margins. Set to `15` horizontal and  `10` vertical.
        public var headerMargins: Margins = GlobalUIModel.Common.containerHeaderMargins

        /// Model for customizing chevron button layout. `dimension` Set to `30`, `iconSize` Set to `12x12`, and `hitBox` Set to `zero`.
        public var chevronButtonSubUIModel: VRoundedButtonUIModel.Layout = {
            var uiModel: VRoundedButtonUIModel.Layout = .init()
            
            uiModel.dimension = GlobalUIModel.Common.circularButtonGrayDimension
            uiModel.iconSize = .init(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
            uiModel.hitBox = .zero
            
            return uiModel
        }()
        
        /// Divider height. Set to `2` scaled to screen.
        ///
        /// To hide divider, set to `0`.
        public var dividerHeight: CGFloat = GlobalUIModel.Common.dividerHeight
        
        /// Divider margins. Set to `15` horizontal and  `0` vertical.
        public var dividerMargins: Margins = .init(
            horizontal: GlobalUIModel.Common.containerContentMargin,
            vertical: 0
        )
        
        /// Content margins. Set to `zero`.
        public var contentMargins: Margins = .zero
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Margins
        /// Model that contains `leading`, `trailing`, `top` and `bottom` and margins.
        public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
    }

    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Background color.
        public var background: Color = ColorBook.layer
        
        /// Header title colors.
        ///
        /// Only applicable when using `init` with title.
        public var headerTitle: StateColors = .init(
            collapsed: ColorBook.primary,
            expanded: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Custom header label opacities.
        ///
        /// Applicable only when `init` with header label is used.
        /// When using a custom header label, it's subviews cannot be configured with individual colors,
        /// so instead, a general opacity is being applied.
        public var customHeaderLabelOpacities: StateOpacities = .init(
            collapsed: 1,
            expanded: 1,
            disabled: 0.3
        )
        
        /// Divider color.
        public var divider: Color = GlobalUIModel.Common.dividerColor
        
        /// Model for customizing chevron button colors.
        public var chevronButtonSubUIModel: VRoundedButtonUIModel.Colors = {
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            
            uiModel.background = .init(
                enabled: GlobalUIModel.Common.circularButtonBackgroundColorEnabled,
                pressed: GlobalUIModel.Common.circularButtonBackgroundColorPressed,
                disabled: GlobalUIModel.Common.circularButtonBackgroundColorDisabled
            )
            uiModel.icon = .init(
                enabled: GlobalUIModel.Common.circularButtonIconPrimaryColorEnabled,
                pressed: GlobalUIModel.Common.circularButtonIconPrimaryColorPressed,
                disabled: GlobalUIModel.Common.circularButtonIconPrimaryColorDisabled
            )
            
            return uiModel
        }()
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: State Colors
        /// Model that contains colors for component states.
        public typealias StateColors = GenericStateModel_CollapsedExpandedDisabled<Color>
        
        // MARK: State Opacities
        /// Model that contains opacities for component states.
        public typealias StateOpacities = GenericStateModel_CollapsedExpandedDisabled<CGFloat>
    }

    // MARK: Fonts
    /// Model that contains font properties.
    public struct Fonts {
        // MARK: Properties
        /// Header title font. Set to `system` `bold`-`17`.
        ///
        /// Only applicable when using `init` with header.
        public var headerTitle: Font = .system(size: 17, weight: .bold)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Expand and collapse animation. Set to `default`.
        public var expandCollapse: Animation? = .default
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Misc
    /// Model that contains misc properties.
    public struct Misc {
        // MARK: Properties
        /// Indicates if disclosure group expands and collapses from header tap. Set to `true`.
        public var expandsAndCollapsesOnHeaderTap: Bool = true
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }

    // MARK: Sub UI Models
    var plainDisclosureGroupSubUIModel: PlainDisclosureGroupUIModel {
        var uiModel: PlainDisclosureGroupUIModel = .init()
        
        uiModel.colors.background = colors.background
        
        uiModel.animations.expandCollapse = animations.expandCollapse
        
        return uiModel
    }
    
    var sheetSubUIModel: VSheetUIModel {
        var uiModel: VSheetUIModel = .init()
        
        uiModel.layout.roundedCorners = .allCorners
        uiModel.layout.cornerRadius = uiModel.layout.cornerRadius
        uiModel.layout.contentMargin = 0
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var chevronButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()

        uiModel.layout = layout.chevronButtonSubUIModel
        
        uiModel.colors = colors.chevronButtonSubUIModel
        
        return uiModel
    }
}

// MARK: - Factory
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = .init(VSheetUIModel.Layout().contentMargin)
        
        return uiModel
    }
}
