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
    // MARK: Properties - General
    var plainDisclosureGroupSubUIModel: PlainDisclosureGroupUIModel {
        var uiModel: PlainDisclosureGroupUIModel = .init()

        uiModel.colors.background = backgroundColor

        uiModel.animations.expandCollapse = expandCollapseAnimation

        return uiModel
    }

    /// Corner radius. Set to `15`.
    public var cornerRadius: CGFloat = GlobalUIModel.Common.containerCornerRadius

    // MARK: Properties - Background
    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.layout.roundedCorners = .allCorners
        uiModel.layout.cornerRadius = uiModel.layout.cornerRadius
        uiModel.layout.contentMargins = .zero

        uiModel.colors.background = backgroundColor

        return uiModel
    }

    /// Background color.
    public var backgroundColor: Color = ColorBook.layer

    // MARK: Properties - Header
    /// Header margins. Set to `15` horizontal and `10` vertical.
    public var headerMargins: Margins = GlobalUIModel.Common.containerHeaderMargins

    /// Indicates if disclosure group expands and collapses from header tap. Set to `true`.
    public var expandsAndCollapsesOnHeaderTap: Bool = true

    // MARK: Properties - Header - Text
    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        collapsed: ColorBook.primary,
        expanded: ColorBook.primary,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Header title tex font.
    /// Set to `bold` `headline` (`17`) on `iOS`.
    /// Set to `bold` `headline` (`13`) on `macOS`.
    public var headerTitleTextFont: Font = .headline.weight(.bold)

    // MARK: Properties - Chevron Button
    /// Model for customizing chevron button.
    /// `size` is set to `30x30`,
    /// `cornerRadius` is set to `16`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `12x12`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var chevronButtonSubUIModel: VRoundedButtonUIModel = {
        var uiModel: VRoundedButtonUIModel = .init()

        uiModel.size = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayDimension)
        uiModel.cornerRadius = 16

        uiModel.backgroundColors = VRoundedButtonUIModel.StateColors(
            enabled: GlobalUIModel.Common.circularButtonLayerColorEnabled,
            pressed: GlobalUIModel.Common.circularButtonLayerColorPressed,
            disabled: GlobalUIModel.Common.circularButtonLayerColorDisabled
        )

        uiModel.iconSize = CGSize(dimension: GlobalUIModel.Common.circularButtonGrayIconDimension)
        uiModel.iconColors = VRoundedButtonUIModel.StateColors(
            enabled: GlobalUIModel.Common.circularButtonIconPrimaryColorEnabled,
            pressed: GlobalUIModel.Common.circularButtonIconPrimaryColorPressed,
            disabled: GlobalUIModel.Common.circularButtonIconPrimaryColorDisabled
        )

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    // MARK: Properties - Divider
    /// Divider height. Set to `2` scaled to screen.
    ///
    /// To hide divider, set to `0`.
    public var dividerHeight: CGFloat = GlobalUIModel.Common.dividerHeight

    /// Divider color.
    public var dividerColor: Color = GlobalUIModel.Common.dividerColor

    /// Divider margins. Set to `15` horizontal and `0` vertical.
    public var dividerMargins: Margins = .init(
        horizontal: GlobalUIModel.Common.containerContentMargin,
        vertical: 0
    )

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    // MARK: Properties - State Change
    /// Indicates if `expandCollapse` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// This property doesn't affect internal expand/collapse button press.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesExpandCollapseAnimation: Bool = true

    /// Expand and collapse animation. Set to `default`.
    public var expandCollapseAnimation: Animation? = .default

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top` and `bottom` and margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_CollapsedExpandedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_CollapsedExpandedDisabled<CGFloat>
}

// MARK: - Factory
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(GlobalUIModel.Common.containerCornerRadius)
        
        return uiModel
    }
}
