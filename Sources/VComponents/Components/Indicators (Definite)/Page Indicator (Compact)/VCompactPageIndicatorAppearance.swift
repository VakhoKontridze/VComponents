//
//  VCompactPageIndicatorAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI
import VCore

/// Model that describes appearance.
public struct VCompactPageIndicatorAppearance: Sendable {
    // MARK: Properties - Global
    /// Direction.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Dot spacing.
    public var spacing: CGFloat = {
#if os(iOS)
        8
#elseif os(macOS)
        8
#elseif os(tvOS)
        10
#elseif os(watchOS)
        4
#elseif os(visionOS)
        10
#endif
    }()

    /// Number of visible dots.
    ///
    /// Must be odd and greater than `centerDots`.
    public var visibleDots: Int = 7

    /// Number of center dots.
    ///
    /// Must be odd and less than `visibleDots`.
    public var centerDots: Int = 3

    /// Number of side dots.
    public var sideDots: Int { (visibleDots - centerDots) / 2 }

    /// Number of middle dots.
    public var middleDots: Int { visibleDots / 2 }

    // MARK: Properties - Dot
    /// Dot width, but height for vertical layout.
    public var dotWidth: CGFloat = {
#if os(iOS)
        8
#elseif os(macOS)
        8
#elseif os(tvOS)
        10
#elseif os(watchOS)
        4
#elseif os(visionOS)
        10
#endif
    }()

    /// Dot height, but width for vertical layout.
    public var dotHeight: CGFloat = {
#if os(iOS)
        8
#elseif os(macOS)
        8
#elseif os(tvOS)
        10
#elseif os(watchOS)
        4
#elseif os(visionOS)
        10
#endif
    }()

    /// Scale of dot at the edge.
    ///
    /// If there are `7` visible dots, and `3` center dots, resulting dot scales would be `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
    public var edgeDotScale: CGFloat = 0.5

    /// Dot corner radii.
    ///
    /// applicable only when `init` without dot content is used.
    public var dotCornerRadii: DotStateDimensions = {
#if os(iOS)
        DotStateDimensions(4)
#elseif os(macOS)
        DotStateDimensions(4)
#elseif os(tvOS)
        DotStateDimensions(5)
#elseif os(watchOS)
        DotStateDimensions(2)
#elseif os(visionOS)
        DotStateDimensions(5)
#endif
    }()

    /// Dot colors.
    public var dotColors: DotStateColors = {
#if os(iOS)
        DotStateColors(
            deselected: Color.dynamic(Color(190, 190, 190), Color(120, 120, 120)),
            selected: Color.blue
        )
#elseif os(macOS)
        DotStateColors(
            deselected: Color.dynamic(Color(190, 190, 190), Color(120, 120, 120)),
            selected: Color.blue
        )
#elseif os(tvOS)
        DotStateColors(
            deselected: Color.dynamic(Color(190, 190, 190), Color(120, 120, 120)),
            selected: Color.blue
        )
#elseif os(watchOS)
        DotStateColors(
            deselected: Color(120, 120, 120),
            selected: Color.blue
        )
#elseif os(visionOS)
        DotStateColors(
            deselected: Color.white.opacity(0.5),
            selected: Color.white
        )
#endif
    }()

    // MARK: Properties - Dot Border
    /// Dot border widths.
    ///
    /// To hide border, set to `zero`.
    ///
    /// applicable only when `init` without dot content is used.
    public var dotBorderWidths: DotStateDimensions = .zero

    /// Dot border colors.
    ///
    /// applicable only when `init` without dot content is used.
    public var dotBorderColors: DotStateColors = .clearColors

    // MARK: Properties - Transition
    /// Indicates if `transition` animation is applied.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesTransitionAnimation: Bool = true

    /// Transition animation.
    public var transitionAnimation: Animation? = .linear(duration: 0.15)

    // MARK: Properties - Standard Layout
    var standardPageIndicatorAppearance: VPageIndicatorAppearance {
        .init(
            direction: direction,
            spacing: spacing,
            dotWidths: VPageIndicatorAppearance.DotStateOptionalDimensions(dotWidth),
            dotHeights: VPageIndicatorAppearance.DotStateDimensions(dotHeight),
            dotCornerRadii: dotCornerRadii,
            dotColors: dotColors,
            dotBorderWidths: dotBorderWidths,
            dotBorderColors: dotBorderColors,
            appliesTransitionAnimation: appliesTransitionAnimation,
            transitionAnimation: transitionAnimation
        )
    }

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Dot State Dimensions
    /// Model that contains dimensions  for component states.
    public typealias DotStateDimensions = GenericStateModel_DeselectedSelected<CGFloat>

    // MARK: Dot State Colors
    /// Model that contains colors for component states.
    public typealias DotStateColors = GenericStateModel_DeselectedSelected<Color>
}

extension VCompactPageIndicatorAppearance {
    /// `VCompactPageIndicatorAppearance` with vertical layout.
    public static var vertical: Self {
        var appearance: Self = .init()

        appearance.direction = .topToBottom

        return appearance
    }
}
