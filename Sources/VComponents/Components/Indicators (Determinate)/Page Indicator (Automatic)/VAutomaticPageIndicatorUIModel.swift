//
//  VAutomaticPageIndicatorUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI
import VCore

// MARK: - V Automatic Page Indicator UI Model
/// Model that describes UI.
public struct VAutomaticPageIndicatorUIModel {
    // MARK: Properties - General
    /// Direction. Set to `leftToRight`.
    public var direction: LayoutDirectionOmni = .leftToRight

    // MARK: Properties - Layout
    /// Limit after which `standard` configuration switches to `compact` one. Set to `10`.
    public var standardDotLimit: Int = 10

    // MARK: Properties - Content
    /// Dot spacing.
    /// Set to `5` on `iOS`.
    /// Set to `5` on `macOS`.
    /// Set to `10` on `tvOS`.
    /// Set to `3` on `watchOS`.
    public var spacing: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorSpacing

    // MARK: Properties - Dot
    /// Dot height, but width for vertical layouts.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    public var dotHeight: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

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
            selectedDotColor: selectedDotColor,
            dotBorderWidth: dotBorderWidth,
            dotBorderColor: dotBorderColor,
            selectedDotBorderColor: selectedDotBorderColor,
            appliesTransitionAnimation: appliesTransitionAnimation,
            transitionAnimation: transitionAnimation
        )
    }

    // MARK: Properties - Compact Layout
    /// Number of visible dots when switching to `compact` configuration. Set to `7`.
    ///
    /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
    public var visibleDotsForCompactConfiguration: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactVisibleDots

    /// Number of center dots when switching to `compact` configuration. Set to `3`.
    ///
    /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
    public var centerDotsForCompactConfiguration: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactCenterDots

    /// Dot width, but height for vertical layouts, when switching to `compact` configuration.
    /// Set to `10` on `iOS`.
    /// Set to `10` on `macOS`.
    /// Set to `20` on `tvOS`.
    /// Set to `8` on `watchOS`.
    public var dotWidthForCompactConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension

    /// Scale of dot at the edge when switching to `compact` configuration. Set to `0.5`.
    ///
    /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
    public var edgeDotScaleForCompactConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactEdgeDotScale

    var compactPageIndicatorSubUIModel: VCompactPageIndicatorUIModel {
        .init(
            direction: direction,
            visibleDots: visibleDotsForCompactConfiguration,
            centerDots: centerDotsForCompactConfiguration,
            spacing: spacing,
            dotWidth: dotWidthForCompactConfiguration,
            dotHeight: dotHeight,
            edgeDotScale: edgeDotScaleForCompactConfiguration,
            dotColor: dotColor,
            selectedDotColor: selectedDotColor,
            dotBorderWidth: dotBorderWidth,
            dotBorderColor: dotBorderColor,
            selectedDotBorderColor: selectedDotBorderColor,
            appliesTransitionAnimation: appliesTransitionAnimation,
            transitionAnimation: transitionAnimation,
            dotWidthForStandardConfiguration: dotWidthForStandardConfiguration,
            unselectedDotScaleForStandardConfiguration: unselectedDotScaleForStandardConfiguration
        )
    }
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}

// MARK: - Factory
extension VAutomaticPageIndicatorUIModel {
    /// `VPageIndicatorAutomaticUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()
        
        uiModel.direction = .topToBottom
        
        return uiModel
    }
}
