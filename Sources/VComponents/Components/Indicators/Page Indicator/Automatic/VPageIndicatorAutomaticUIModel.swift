//
//  VPageIndicatorAutomaticUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI
import VCore

// MARK: - V Page Indicator Automatic UI Model
/// Model that describes UI.
public struct VPageIndicatorAutomaticUIModel {
    // MARK: Properties
    fileprivate static let pageIndicatorStandardReference: VPageIndicatorStandardUIModel = .init()
    fileprivate static let pageIndicatorCompactReference: VPageIndicatorCompactUIModel = .init()
    
    /// Sub-model containing layout properties.
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties.
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties.
    public var animations: Animations = .init()
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
    
    // MARK: Layout
    /// Sub-model containing layout properties.
    public struct Layout {
        // MARK: Properties
        /// Direction. Defaults to `leftToRight`.
        public var direction: OmniLayoutDirection = pageIndicatorStandardReference.layout.direction
        
        /// Dot dimension on the main axis when switching to `standard` configuration. Defaults to `10`.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        ///
        /// Set to `nil`, to make dot stretch to take available space.
        public var dotDimensionPrimaryAxisForStandardConfiguration: CGFloat? = pageIndicatorStandardReference.layout.dotDimensionPrimaryAxis
        
        /// Dot dimension on the main axis when switching to `compact` configuration. Defaults to `10`.
        ///
        /// For horizontal layouts, this will be width, and for vertical, height.
        public var dotDimensionPrimaryAxisForCompactConfiguration: CGFloat = pageIndicatorCompactReference.layout.dotDimensionPrimaryAxis
        
        /// Dot dimension on the secondary axis. Defaults to `10`.
        ///
        /// For horizontal layouts, this will be height, and for vertical, width.
        public var dotDimensionSecondaryAxis: CGFloat = pageIndicatorStandardReference.layout.dotDimensionSecondaryAxis
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = pageIndicatorStandardReference.layout.spacing
        
        /// Number of visible dots when switching to `compact` configuration. Default to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDotsForCompactConfiguration: Int = pageIndicatorCompactReference.layout.visibleDots
        
        /// Number of center dots when switching to `compact` configuration. Default to `7`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDotsForCompactConfiguration: Int = pageIndicatorCompactReference.layout.centerDots
        
        /// Limit after which `standard` configuration switches to `compact` one. Defaults to `10`.
        public var standardDotLimit: Int = 10

        /// Unselected dot scale when switching to `standard` configuration. Defaults to `0.85`.
        public var unselectedDotScaleForStandardConfiguration: CGFloat = pageIndicatorStandardReference.layout.unselectedDotScale
        
        /// Scale of dot at the edge when switching to `compact` configuration. Defaults to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScaleForCompactConfiguration: CGFloat = pageIndicatorCompactReference.layout.edgeDotScale
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VPageIndicatorStandardUIModel.Colors

    // MARK: Animations
    /// Sub-model containing animation properties.
    public typealias Animations = VPageIndicatorStandardUIModel.Animations
    
    // MARK: Sub-Models
    var standardPageIndicatorSubUIModel: VPageIndicatorStandardUIModel {
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
    
    var compactPageIndicatorSubUIModel: VPageIndicatorCompactUIModel {
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
extension VPageIndicatorAutomaticUIModel {
    /// `VPageIndicatorFiniteUIModel` with vertical layout.
    public static var vertical: VPageIndicatorAutomaticUIModel {
        var uiModel: VPageIndicatorAutomaticUIModel = .init()
        
        uiModel.layout.direction = .topToBottom
        
        return uiModel
    }
}
