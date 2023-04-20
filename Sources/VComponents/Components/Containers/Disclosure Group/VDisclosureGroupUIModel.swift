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
@available(iOS 14.0, macOS 11.0, *)
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
        
        /// Model for customizing chevron button layout. `size` is set to `30x30`, `cornerRadius` is set to `16`, iconSize` is set to `12x12`, and `hitBox` is set to `zero`.
        public var chevronButtonSubUIModel: VRoundedButtonUIModel.Layout = {
            var uiModel: VRoundedButtonUIModel.Layout = .init()
            
            uiModel.size = .init(dimension: GlobalUIModel.Common.circularButtonGrayDimension)
            uiModel.cornerRadius = 16
            uiModel.iconSize = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
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
        public var headerTitle: StateColors = .init(
            collapsed: ColorBook.primary,
            expanded: ColorBook.primary,
            disabled: ColorBook.primaryPressedDisabled
        )
        
        /// Divider color.
        public var divider: Color = GlobalUIModel.Common.dividerColor
        
        /// Model for customizing chevron button colors.
        public var chevronButtonSubUIModel: VRoundedButtonUIModel.Colors = {
            var uiModel: VRoundedButtonUIModel.Colors = .init()
            
            uiModel.background = VRoundedButtonUIModel.Colors.StateColors(
                enabled: GlobalUIModel.Common.circularButtonLayerColorEnabled,
                pressed: GlobalUIModel.Common.circularButtonLayerColorPressed,
                disabled: GlobalUIModel.Common.circularButtonLayerColorDisabled
            )
            uiModel.icon = VRoundedButtonUIModel.Colors.StateColors(
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
        /// Header title font.
        /// Set to `bold` `headline` (`17`) on `iOS`.
        /// Set to `bold` `headline` (`13`) on `macOS`.
        public var headerTitle: Font = .headline.weight(.bold)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Indicates if `expandCollapse` animation is applied. Defaults to `true`.
        ///
        /// This property doesn't affect internal expand/collapse button press.
        ///
        /// If  animation is set to `nil`, a `nil` animation is still applied.
        /// If this property is set to `false`, then no animation is applied.
        ///
        /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
        public var appliesExpandCollapseAnimation: Bool = true
        
        /// Expand and collapse animation. Set to `default`.
        public var expandCollapse: Animation? = .default
        
        /// Model for customizing chevron button animations. `haptic` is set to `nil`.
        public var chevronButtonSubUIModel: VRoundedButtonUIModel.Animations = {
            var uiModel: VRoundedButtonUIModel.Animations = .init()
            
#if os(iOS)
            uiModel.haptic = nil
#endif
            
            return uiModel
        }()
        
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
        uiModel.layout.contentMargins = .zero
        
        uiModel.colors.background = colors.background
        
        return uiModel
    }
    
    var chevronButtonSubUIModel: VRoundedButtonUIModel {
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout = layout.chevronButtonSubUIModel
        
        uiModel.colors = colors.chevronButtonSubUIModel
        
        uiModel.animations = animations.chevronButtonSubUIModel
        
        return uiModel
    }
}

// MARK: - Factory
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.contentMargins = .init(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
}
