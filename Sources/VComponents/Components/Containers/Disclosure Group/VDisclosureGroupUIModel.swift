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
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VDisclosureGroupUIModel {
    // MARK: Properties - Global
    var plainDisclosureGroupSubUIModel: PlainDisclosureGroupUIModel {
        var uiModel: PlainDisclosureGroupUIModel = .init()

        uiModel.backgroundColor = Color.clear // Color is handled in `groupBoxSubUIModel`

        uiModel.expandCollapseAnimation = expandCollapseAnimation

        return uiModel
    }

    // MARK: Properties - Corners
    /// Corner radius. Set to `15`.
    public var cornerRadius: CGFloat = 15

    // MARK: Properties - Background
    var groupBoxSubUIModel: VGroupBoxUIModel {
        var uiModel: VGroupBoxUIModel = .init()

        uiModel.roundedCorners = .allCorners
        uiModel.cornerRadius = cornerRadius

        uiModel.backgroundColor = backgroundColor

        uiModel.contentMargins = .zero

        return uiModel
    }

    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.secondarySystemBackground)
#elseif os(macOS)
        Color.dynamic(Color.black.opacity(0.03), Color.black.opacity(0.15))
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Header
    /// Header margins. Set to `(15, 15, 10, 10)`.
    public var headerMargins: Margins = .init(
        horizontal: 15,
        vertical: 10
    )

    /// Indicates if disclosure group expands and collapses from header tap. Set to `true`.
    public var expandsAndCollapsesOnHeaderTap: Bool = true

    // MARK: Properties - Header - Text
    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        collapsed: Color.primary,
        expanded: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Header title tex font.
    /// Set to `bold` `headline` on `iOS`.
    /// Set to `bold` `headline` on `macOS`.
    public var headerTitleTextFont: Font = .headline.weight(.bold)

    // MARK: Properties - Disclosure Button
    /// Disclosure button icon.
    public var disclosureButtonIcon: Image = ImageBook.chevronUp.renderingMode(.template)

    /// Model for customizing disclosure button.
    /// `size` is set to `(30, 30)`,
    /// `cornerRadius` is set to `16`,
    /// `backgroundColors` are changed,
    /// `iconSize` is set to `(12, 12)`,
    /// `iconColors` are changed,
    /// `hitBox` is set to `zero`,
    /// `haptic` is set to `nil`.
    public var disclosureButtonSubUIModel: VRectangularButtonUIModel = {
        var uiModel: VRectangularButtonUIModel = .init()

        uiModel.size = CGSize(dimension: 30)
        uiModel.cornerRadius = 16

        uiModel.backgroundColors = {
#if os(iOS)
            VRectangularButtonUIModel.StateColors(
                enabled: Color.dynamic(Color(220, 220, 220), Color(60, 60, 60)),
                pressed: Color.dynamic(Color(200, 200, 200), Color(40, 40, 40)),
                disabled: Color.dynamic(Color(230, 230, 230), Color(40, 40, 40))
            )
#elseif os(macOS)
            VRectangularButtonUIModel.StateColors(
                enabled: Color.dynamic(Color.black.opacity(0.1), Color(60, 60, 60)),
                pressed: Color.dynamic(Color.black.opacity(0.15), Color(40, 40, 40)),
                disabled: Color.dynamic(Color.black.opacity(0.05), Color(40, 40, 40))
            )
#else
            fatalError() // Not supported
#endif
        }()

        uiModel.iconSize = CGSize(dimension: 12)
        uiModel.iconColors = VRectangularButtonUIModel.StateColors(
            enabled: Color.primary,
            pressed: Color.primary,
            disabled: Color.primary.opacity(0.3)
        )

        uiModel.hitBox = .zero

#if os(iOS)
        uiModel.haptic = nil
#endif

        return uiModel
    }()

    /// Disclosure button angles in radians.
    public var disclosureButtonAngles: StateAngles = .init(
        collapsed: CGFloat.pi/2,
        expanded: CGFloat.pi,
        disabled: CGFloat.pi/2
    )

    // MARK: Properties - Divider
    /// Divider height. Set to `2`pixels.
    ///
    /// To hide divider, set to `0`.
    public var dividerHeight: PointPixelMeasurement = .pixels(2)

    /// Divider color.
    public var dividerColor: Color = .platformDynamic(Color(60, 60, 60, 0.3), Color(120, 120, 120, 0.6))

    /// Divider margins. Set to `(15, 15, 0, 0)`.
    public var dividerMargins: Margins = .init(
        horizontal: 15,
        vertical: 0
    )

    // MARK: Properties - Content
    /// Content margins. Set to `zero`.
    public var contentMargins: Margins = .zero

    // MARK: Properties - Transition
    /// Indicates if `expandCollapse` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// This property doesn't affect internal expand/collapse button press.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
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

    // MARK: State Angles
    /// Model that contains angles for component states.
    public typealias StateAngles = GenericStateModel_CollapsedExpandedDisabled<CGFloat>
}

// MARK: - Factory
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` that insets content.
    public static var insettedContent: Self {
        var uiModel: Self = .init()
        
        uiModel.contentMargins = Margins(uiModel.cornerRadius)

        return uiModel
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VDisclosureGroupUIModel {
    /// `VDisclosureGroupUIModel` with `UIColor.systemBackground` to be used on `UIColor.secondarySystemBackground`.
    public static var systemBackgroundColor: Self {
        var uiModel: Self = .init()

#if os(iOS)
        uiModel.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        uiModel.disclosureButtonSubUIModel.backgroundColors = VRectangularButtonUIModel.StateColors(
            enabled: Color.dynamic(Color(230, 230, 230), Color(60, 60, 60)),
            pressed: Color.dynamic(Color(210, 210, 210), Color(40, 40, 40)),
            disabled: Color.dynamic(Color(240, 240, 240), Color(40, 40, 40))
        )

        return uiModel
    }
}
