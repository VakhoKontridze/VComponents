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
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Dot spacing.
    /// Set to `5` on `iOS`.
    /// Set to `5` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `3` on `watchOS`.
    public var spacing: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorSpacing

    /// Number of visible dots. Set to `7`.
    ///
    /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
    public var visibleDots: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactVisibleDots

    /// Number of center dots. Set to `3`.
    ///
    /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
    public var centerDots: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactCenterDots

    /// Number of side dots. Set to half of difference between `visibleDots` and `centerDots`.
    public var sideDots: Int { (visibleDots - centerDots) / 2 }

    /// Number of middle dots. Set to half of `visibleDots.`
    public var middleDots: Int { visibleDots / 2 }

    // MARK: Properties - Dot
    /// Dot width, but height for vertical layouts.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    public var dotWidth: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Dot height, but width for vertical layouts.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    public var dotHeight: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Scale of dot at the edge. Set to `0.5`.
    ///
    /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
    public var edgeDotScale: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactEdgeDotScale

    /// Dot color.
    public var dotColor: Color = GlobalUIModel.DeterminateIndicators.pageIndicatorDotColor

    /// Selected dot color.
    public var selectedDotColor: Color = GlobalUIModel.DeterminateIndicators.pageIndicatorSelectedDotColor

    // MARK: Properties - Dot Border
    /// Border width. Set to `0.`
    ///
    /// To hide border, set to `0`.
    public var dotBorderWidth: CGFloat = 0

    /// Dot border color.
    public var dotBorderColor: Color = .clear

    /// Selected dot border color.
    public var selectedDotBorderColor: Color = .clear

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
    public var transitionAnimation: Animation? = GlobalUIModel.DeterminateIndicators.pageIndicatorTransitionAnimation

    // MARK: Properties - Standard Layout
    /// Dot width, but height for vertical layouts, when switching to `standard` configuration.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    ///
    /// Set to `nil`, to make dot stretch to take available space.
    public var dotWidthForStandardConfiguration: CGFloat? = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Unselected dot scale when switching to `standard` configuration. Set to `0.85`.
    public var unselectedDotScaleForStandardConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorStandardUnselectedDotScale

    var standardPageIndicatorSubUIModel: VPageIndicatorUIModel {
        .init(
            direction: direction,
            spacing: spacing,
            dotWidth: dotWidthForStandardConfiguration,
            dotHeight: dotHeight,
            unselectedDotScale: unselectedDotScaleForStandardConfiguration,
            dotColor: dotColor,
            selectedDotColor: selectedDotBorderColor,
            dotBorderWidth: dotBorderWidth,
            dotBorderColor: dotBorderColor,
            selectedDotBorderColor: selectedDotBorderColor,
            appliesTransitionAnimation: appliesTransitionAnimation,
            transitionAnimation: transitionAnimation
        )
    }

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    init(
        direction: LayoutDirectionOmni,
        visibleDots: Int,
        centerDots: Int,
        spacing: CGFloat,
        dotWidth: CGFloat,
        dotHeight: CGFloat,
        edgeDotScale: CGFloat,
        dotColor: Color,
        selectedDotColor: Color,
        dotBorderWidth: CGFloat,
        dotBorderColor: Color,
        selectedDotBorderColor: Color,
        appliesTransitionAnimation: Bool,
        transitionAnimation: Animation?,
        dotWidthForStandardConfiguration: CGFloat?,
        unselectedDotScaleForStandardConfiguration: CGFloat
    ) {
        self.direction = direction
        self.visibleDots = visibleDots
        self.centerDots = centerDots
        self.spacing = spacing
        self.dotWidth = dotWidth
        self.dotHeight = dotHeight
        self.edgeDotScale = edgeDotScale
        self.dotColor = dotColor
        self.selectedDotColor = selectedDotColor
        self.dotBorderWidth = dotBorderWidth
        self.dotBorderColor = dotBorderColor
        self.selectedDotBorderColor = selectedDotBorderColor
        self.appliesTransitionAnimation = appliesTransitionAnimation
        self.transitionAnimation = transitionAnimation
        self.dotWidthForStandardConfiguration = dotWidthForStandardConfiguration
        self.unselectedDotScaleForStandardConfiguration = unselectedDotScaleForStandardConfiguration
    }
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
