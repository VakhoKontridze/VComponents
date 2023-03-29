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
        
        /// Dot dimension on the main axis when switching to `standard` configuration. Set to `20` for `tvOS`, `8` for `watchOS`, and `10` for other platforms.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotDimensionPrimaryAxisForStandardConfiguration: CGFloat? = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot dimension on the main axis when switching to `compact` configuration. Set to `20` for `tvOS`, `8` for `watchOS`, and `10` for other platforms.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        public var dotDimensionPrimaryAxisForCompactConfiguration: CGFloat = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot dimension on the secondary axis. Set to `20` for `tvOS`, `8` for `watchOS`, and `10` for other platforms.
        ///
        /// For horizontal layouts, this will be height, and for vertical, width.
        public var dotDimensionSecondaryAxis: CGFloat = GlobalUIModel.Indicators.pageIndicatorDotDimension
        
        /// Dot spacing. Set to `10` for `tvOS`, `3` for `watchOS`, and `5` for other platforms.
        public var spacing: CGFloat = GlobalUIModel.Indicators.pageIndicatorSpacing
        
        /// Number of visible dots when switching to `compact` configuration. Set to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDotsForCompactConfiguration: Int = GlobalUIModel.Indicators.pageIndicatorCompactVisibleDots
        
        /// Number of center dots when switching to `compact` configuration. Set to `3`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDotsForCompactConfiguration: Int = GlobalUIModel.Indicators.pageIndicatorCompactCenterDots
        
        /// Limit after which `standard` configuration switches to `compact` one. Set to `10`.
        public var standardDotLimit: Int = 10

        /// Unselected dot scale when switching to `standard` configuration. Set to `0.85`.
        public var unselectedDotScaleForStandardConfiguration: CGFloat = GlobalUIModel.Indicators.pageIndicatorStandardUnselectedDotScale
        
        /// Scale of dot at the edge when switching to `compact` configuration. Set to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScaleForCompactConfiguration: CGFloat = GlobalUIModel.Indicators.pageIndicatorCompactEdgeDotScale
        
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
            layout: .init(
                direction: layout.direction,
                dotDimensionPrimaryAxis: layout.dotDimensionPrimaryAxisForStandardConfiguration,
                dotDimensionSecondaryAxis: layout.dotDimensionSecondaryAxis,
                spacing: layout.spacing,
                unselectedDotScale: layout.unselectedDotScaleForStandardConfiguration
            ),
            colors: colors,
            animations: animations
        )
    }
    
    var compactPageIndicatorSubUIModel: VCompactPageIndicatorUIModel {
        .init(
            layout: .init(
                direction: layout.direction,
                dotDimensionPrimaryAxis: layout.dotDimensionPrimaryAxisForCompactConfiguration,
                dotDimensionPrimaryAxisForStandardConfiguration: layout.dotDimensionPrimaryAxisForStandardConfiguration,
                dotDimensionSecondaryAxis: layout.dotDimensionSecondaryAxis,
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
