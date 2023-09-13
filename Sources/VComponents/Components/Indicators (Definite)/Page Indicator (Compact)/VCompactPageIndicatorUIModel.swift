//
//  VCompactPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI
import VCore

// MARK: - V Compact Page Indicator UI Model
/// Model that describes UI.
public struct VCompactPageIndicatorUIModel {
    // MARK: Properties - Global Layout
    /// Direction. Set to `leftToRight`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Dot spacing.
    /// Set to `8` on `iOS`.
    /// Set to `8` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `4` on `watchOS`.
    public var spacing: CGFloat = GlobalUIModel.DefiniteIndicators.pageIndicatorSpacing

    /// Number of visible dots. Set to `7`.
    ///
    /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
    public var visibleDots: Int = GlobalUIModel.DefiniteIndicators.pageIndicatorCompactVisibleDots

    /// Number of center dots. Set to `3`.
    ///
    /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
    public var centerDots: Int = GlobalUIModel.DefiniteIndicators.pageIndicatorCompactCenterDots

    /// Number of side dots. Set to the half of difference between `visibleDots` and `centerDots`.
    public var sideDots: Int { (visibleDots - centerDots) / 2 }

    /// Number of middle dots. Set to the half of `visibleDots`.
    public var middleDots: Int { visibleDots / 2 }

    // MARK: Properties - Dot
    /// Dot width, but height for vertical layout.
    /// Set to `8` on `iOS`.
    /// Set to `8` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `4` on `watchOS`.
    public var dotWidth: CGFloat = GlobalUIModel.DefiniteIndicators.pageIndicatorDotDimension

    /// Dot height, but width for vertical layout.
    /// Set to `8` on `iOS`.
    /// Set to `8` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `4` on `watchOS`.
    public var dotHeight: CGFloat = GlobalUIModel.DefiniteIndicators.pageIndicatorDotDimension

    /// Scale of dot at the edge. Set to `0.5`.
    ///
    /// If there are `7` visible dots, and `3` center dots, resulting dot scales would be `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
    public var edgeDotScale: CGFloat = GlobalUIModel.DefiniteIndicators.pageIndicatorCompactEdgeDotScale

    /// Dot corner radii.
    /// Set to `4`s on `iOS`.
    /// Set to `4`s on `macOS`.
    /// Set to `5`s on `tvOS`.
    /// Set to `2`s on `watchOS`.
    ///
    /// Applicable on when `init` without dot content is used.
    public var dotCornerRadii: DotStateDimensions = .init(GlobalUIModel.DefiniteIndicators.pageIndicatorDotCornerRadius)

    /// Dot colors.
    public var dotColors: DotStateColors = .init(
        deselected: GlobalUIModel.DefiniteIndicators.pageIndicatorDeselectedDotColor,
        selected: GlobalUIModel.DefiniteIndicators.pageIndicatorSelectedDotColor
    )

    // MARK: Properties - Dot Border
    /// Dot border widths. Set to `0`s.
    ///
    /// To hide border, set to `0`s.
    ///
    /// Applicable on when `init` without dot content is used.
    public var dotBorderWidths: DotStateDimensions = .zero

    /// Dot border colors.
    ///
    /// Applicable on when `init` without dot content is used.
    public var dotBorderColors: DotStateColors = .clearColors

    // MARK: Properties - Transition
    /// Indicates if `transition` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesTransitionAnimation: Bool = true

    /// Transition animation. Set to `linear` with duration `0.15`.
    public var transitionAnimation: Animation? = GlobalUIModel.DefiniteIndicators.pageIndicatorTransitionAnimation

    // MARK: Properties - Standard Layout
    var standardPageIndicatorSubUIModel: VPageIndicatorUIModel {
        .init(
            direction: direction,
            spacing: spacing,
            dotWidths: VPageIndicatorUIModel.DotStateOptionalDimensions(dotWidth),
            dotHeights: VPageIndicatorUIModel.DotStateDimensions(dotHeight),
            dotColors: dotColors,
            dotBorderWidths: dotBorderWidths,
            dotCornerRadii: dotCornerRadii,
            dotBorderColors: dotBorderColors,
            appliesTransitionAnimation: appliesTransitionAnimation,
            transitionAnimation: transitionAnimation
        )
    }

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Dot State Dimensions
    /// Model that contains dimensions  for component states.
    public typealias DotStateDimensions = GenericStateModel_DeselectedSelected<CGFloat>

    // MARK: Dot State Colors
    /// Model that contains colors for component states.
    public typealias DotStateColors = GenericStateModel_DeselectedSelected<Color>
}

// MARK: - Factory
extension VCompactPageIndicatorUIModel {
    /// `VCompactPageIndicatorUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()

        uiModel.direction = .topToBottom

        return uiModel
    }
}
