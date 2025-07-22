//
//  VPageIndicatorAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator Appearance
/// Model that describes appearance.
@MemberwiseInitializable(
    accessLevelModifier: .internal,
    parameterDefaultValues: ["*": .omit]
)
public struct VPageIndicatorAppearance: Sendable {
    // MARK: Properties - Global
    /// Direction.
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

    // MARK: Properties - Dot
    /// Dot widths, but heights for vertical layout.
    ///
    /// Set to `nil`s, to make dot stretch to take available space.
    public var dotWidths: DotStateOptionalDimensions = {
#if os(iOS)
        DotStateOptionalDimensions(8)
#elseif os(macOS)
        DotStateOptionalDimensions(8)
#elseif os(tvOS)
        DotStateOptionalDimensions(10)
#elseif os(watchOS)
        DotStateOptionalDimensions(4)
#elseif os(visionOS)
        DotStateOptionalDimensions(10)
#endif
    }()

    /// Dot heights, but widths for vertical layout.
    public var dotHeights: DotStateDimensions = {
#if os(iOS)
        DotStateDimensions(8)
#elseif os(macOS)
        DotStateDimensions(8)
#elseif os(tvOS)
        DotStateDimensions(10)
#elseif os(watchOS)
        DotStateDimensions(4)
#elseif os(visionOS)
        DotStateDimensions(10)
#endif
    }()

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
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesTransitionAnimation: Bool = true

    /// Transition animation.
    public var transitionAnimation: Animation? = .linear(duration: 0.15)
    
    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Dot State Dimensions
    /// Model that contains dimensions  for component states.
    public typealias DotStateDimensions = GenericStateModel_DeselectedSelected<CGFloat>

    // MARK: Dot State Optional Dimensions
    /// Model that contains dimensions  for component states.
    public typealias DotStateOptionalDimensions = GenericStateModel_DeselectedSelected<CGFloat?>

    // MARK: Dot State Colors
    /// Model that contains colors for component states.
    public typealias DotStateColors = GenericStateModel_DeselectedSelected<Color>
}

// MARK: - Factory
extension VPageIndicatorAppearance {
    /// `VPageIndicatorAppearance` with vertical layout.
    public static var vertical: Self {
        var appearance: Self = .init()
        
        appearance.direction = .topToBottom
        
        return appearance
    }
}
