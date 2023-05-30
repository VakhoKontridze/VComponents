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
    // MARK: Properties
    /// Model that contains layout properties.
    public var layout: Layout = .init()
    
    /// Model that contains color properties.
    public var colors: Colors = .init()
    
    /// Model that contains animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Model that contains layout properties.
    public struct Layout {
        // MARK: Properties
        /// Direction. Set to `leftToRight`.
        public var direction: LayoutDirectionOmni = .leftToRight
        
        /// Dot width, but height for vertical layouts, when switching to `standard` configuration.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotWidthForStandardConfiguration: CGFloat? = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension
        
        /// Dot width, but height for vertical layouts, when switching to `compact` configuration.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        public var dotWidthForCompactConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension
        
        /// Dot height, but width for vertical layouts.
        /// Set to `10` on `iOS`.
        /// Set to `10` on `macOS`.
        /// Set to `20` on `tvOS`.
        /// Set to `8` on `watchOS`.
        public var dotHeight: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorDotDimension
        
        /// Border width. Set to `0.`
        ///
        /// To hide border, set to `0`.
        public var dotBorderWidth: CGFloat = 0
        
        /// Dot spacing.
        /// Set to `5` on `iOS`.
        /// Set to `5` on `macOS`.
        /// Set to `10` on `tvOS`.
        /// Set to `3` on `watchOS`.
        public var spacing: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorSpacing
        
        /// Number of visible dots when switching to `compact` configuration. Set to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDotsForCompactConfiguration: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactVisibleDots
        
        /// Number of center dots when switching to `compact` configuration. Set to `3`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDotsForCompactConfiguration: Int = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactCenterDots
        
        /// Limit after which `standard` configuration switches to `compact` one. Set to `10`.
        public var standardDotLimit: Int = 10
        
        /// Unselected dot scale when switching to `standard` configuration. Set to `0.85`.
        public var unselectedDotScaleForStandardConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorStandardUnselectedDotScale
        
        /// Scale of dot at the edge when switching to `compact` configuration. Set to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScaleForCompactConfiguration: CGFloat = GlobalUIModel.DeterminateIndicators.pageIndicatorCompactEdgeDotScale
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public typealias Colors = VPageIndicatorUIModel.Colors
    
    // MARK: Animations
    /// Model that contains animation properties.
    public typealias Animations = VPageIndicatorUIModel.Animations
    
    // MARK: Sub UI Models
    var standardPageIndicatorSubUIModel: VPageIndicatorUIModel {
        .init(
            layout: VPageIndicatorUIModel.Layout(
                direction: layout.direction,
                dotWidth: layout.dotWidthForStandardConfiguration,
                dotHeight: layout.dotHeight,
                dotBorderWidth: layout.dotBorderWidth,
                unselectedDotScale: layout.unselectedDotScaleForStandardConfiguration,
                spacing: layout.spacing
            ),
            colors: colors,
            animations: animations
        )
    }
    
    var compactPageIndicatorSubUIModel: VCompactPageIndicatorUIModel {
        .init(
            layout: VCompactPageIndicatorUIModel.Layout(
                direction: layout.direction,
                dotWidth: layout.dotWidthForCompactConfiguration,
                dotWidthForStandardConfiguration: layout.dotWidthForStandardConfiguration,
                dotHeight: layout.dotHeight,
                spacing: layout.spacing,
                visibleDots: layout.visibleDotsForCompactConfiguration,
                centerDots: layout.centerDotsForCompactConfiguration,
                edgeDotScale: layout.edgeDotScaleForCompactConfiguration,
                unselectedDotScaleForStandardConfiguration: layout.unselectedDotScaleForStandardConfiguration
            ),
            colors: colors,
            animations: animations
        )
    }
}

// MARK: - Factory
extension VAutomaticPageIndicatorUIModel {
    /// `VPageIndicatorAutomaticUIModel` with vertical layout.
    public static var vertical: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.direction = .topToBottom
        
        return uiModel
    }
}
