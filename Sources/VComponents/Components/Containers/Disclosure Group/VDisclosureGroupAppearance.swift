//
//  VDisclosureGroupAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import SwiftUI
import VCore

// MARK: - V Disclosure Group Appearance
/// Model that describes appearance.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VDisclosureGroupAppearance: Sendable {
    // MARK: Properties - Global
    var plainDisclosureGroupAppearance: PlainDisclosureGroupAppearance {
        var appearance: PlainDisclosureGroupAppearance = .init()

        appearance.backgroundColor = Color.clear // Color is handled in `groupBoxAppearance`

        appearance.expandCollapseAnimation = expandCollapseAnimation

        return appearance
    }

    // MARK: Properties - Corners
    /// Corner radii.
    public var cornerRadii: RectangleCornerRadii = .init(15)

    /// Indicates if horizontal corners should switch to support RTL languages.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
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

    func groupBoxAppearance(
        internalState: VDisclosureGroupInternalState
    ) -> VGroupBoxAppearance {
        var appearance: VGroupBoxAppearance = .init()

        appearance.cornerRadii = cornerRadii
        appearance.reversesHorizontalCornersForRTLLanguages = reversesHorizontalCornersForRTLLanguages

        appearance.backgroundColor = backgroundColor

        appearance.borderWidth = borderWidth
        appearance.borderColor = borderColors.value(for: internalState)

        appearance.contentMargins = EdgeInsets()

        return appearance
    }

    // MARK: Properties - Border
    /// Border width. 
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#else
        fatalError() // Not supported
#endif
    }()

    /// Border colors.
    public var borderColors: StateColors = {
#if os(iOS)
        StateColors.clearColors
#elseif os(macOS)
        StateColors(
            collapsed: Color.dynamic(Color(200, 200, 200), Color(100, 100, 100)),
            expanded: Color.dynamic(Color(200, 200, 200), Color(100, 100, 100)),
            disabled: Color.dynamic(Color(230, 230, 230), Color(70, 70, 70))
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Header
    /// Header margins.
    public var headerMargins: EdgeInsets = .init(horizontal: 15, vertical: 10)

    /// Indicates if disclosure group expands and collapses from header tap.
    public var expandsAndCollapsesOnHeaderTap: Bool = true

    // MARK: Properties - Header - Text
    /// Header title text minimum scale factor.
    public var headerTitleTextMinimumScaleFactor: CGFloat = 1
    
    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        collapsed: Color.primary,
        expanded: Color.primary,
        disabled: Color.primary.opacity(0.3)
    )

    /// Header title tex font.
    public var headerTitleTextFont: Font = .headline.weight(.bold)

    /// Header title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var headerTitleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Disclosure Button
    /// Disclosure button icon.
    public var disclosureButtonIcon: Image = ImageBook.chevronUp.renderingMode(.template)

    /// Disclosure button appearance.
    public var disclosureButtonAppearance: VRectangularButtonAppearance = {
        var appearance: VRectangularButtonAppearance = .init()

        appearance.size = CGSize(dimension: 30)
        appearance.cornerRadius = 16

        appearance.backgroundColors = {
#if os(iOS)
            VRectangularButtonAppearance.StateColors(
                enabled: Color.dynamic(Color(220, 220, 220), Color(60, 60, 60)),
                pressed: Color.dynamic(Color(200, 200, 200), Color(40, 40, 40)),
                disabled: Color.dynamic(Color(230, 230, 230), Color(40, 40, 40))
            )
#elseif os(macOS)
            VRectangularButtonAppearance.StateColors(
                enabled: Color.dynamic(Color.black.opacity(0.1), Color(60, 60, 60)),
                pressed: Color.dynamic(Color.black.opacity(0.15), Color(40, 40, 40)),
                disabled: Color.dynamic(Color.black.opacity(0.05), Color(40, 40, 40))
            )
#else
            fatalError() // Not supported
#endif
        }()

        appearance.iconSize = CGSize(dimension: 12)
        appearance.iconColors = VRectangularButtonAppearance.StateColors(
            enabled: Color.primary,
            pressed: Color.primary,
            disabled: Color.primary.opacity(0.3)
        )

        appearance.hitBox = EdgeInsets()

#if os(iOS)
        appearance.haptic = nil
#endif

        return appearance
    }()

    /// Disclosure button angles in radians.
    public var disclosureButtonAngles: StateAngles = .init(
        collapsed: CGFloat.pi/2,
        expanded: CGFloat.pi,
        disabled: CGFloat.pi/2
    )

    // MARK: Properties - Divider
    /// Divider height.
    ///
    /// To hide divider, set to `0`.
    public var dividerHeight: PointPixelMeasurement = .pixels(2)

    /// Divider color.
    public var dividerColor: Color = .platformDynamic(Color(60, 60, 60, 0.3), Color(120, 120, 120, 0.6))

    /// Divider margins.
    public var dividerMargins: EdgeInsets = .init(
        horizontal: 15,
        vertical: 0
    )

    // MARK: Properties - Content
    /// Content margins.
    public var contentMargins: EdgeInsets = .init()

    // MARK: Properties - Transition - Expand/Collapse
    /// Indicates if `expandCollapse` animation is applied.
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

    /// Expand and collapse animation.
    public var expandCollapseAnimation: Animation? = .default

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

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
extension VDisclosureGroupAppearance {
    /// `VDisclosureGroupAppearance` that insets content.
    public static var insettedContent: Self {
        var appearance: Self = .init()
        
        appearance.contentMargins = EdgeInsets(15)

        return appearance
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VDisclosureGroupAppearance {
    /// `VDisclosureGroupAppearance` with `UIColor.systemBackground` to be used on `UIColor.secondarySystemBackground`.
    public static var systemBackgroundColor: Self {
        var appearance: Self = .init()

#if os(iOS)
        appearance.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        appearance.disclosureButtonAppearance.backgroundColors = VRectangularButtonAppearance.StateColors(
            enabled: Color.platformDynamic(Color(230, 230, 230), Color(60, 60, 60)),
            pressed: Color.platformDynamic(Color(210, 210, 210), Color(40, 40, 40)),
            disabled: Color.platformDynamic(Color(240, 240, 240), Color(40, 40, 40))
        )

        return appearance
    }
}
