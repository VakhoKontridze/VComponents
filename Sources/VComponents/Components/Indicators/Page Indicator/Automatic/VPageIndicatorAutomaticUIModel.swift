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
        
        /// Number of visible dots. Default to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDots: Int = pageIndicatorCompactReference.layout.visibleDots
        
        /// Number of center dots. Default to `7`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDots: Int = pageIndicatorCompactReference.layout.centerDots
        
        /// Limit after which `standard` configuration switches to `compact` one. Defaults to `10`.
        public var standardDotLimit: Int = 10
        
        /// Dot dimension. Defaults to `10`.
        public var dotDimension: CGFloat = pageIndicatorStandardReference.layout.dotDimension

        /// Unselected dot scale during `standard` configuration. Defaults to `0.85`.
        public var unselectedDotScaleForStandardConfiguration: CGFloat = pageIndicatorStandardReference.layout.unselectedDotScale
        
        /// Scale of dot at the edge during `compact` configuration. Defaults to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScaleForCompactConfiguration: CGFloat = pageIndicatorCompactReference.layout.edgeDotScale
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = pageIndicatorStandardReference.layout.spacing
        
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
    var standardSubModel: VPageIndicatorStandardUIModel {
        var uiModel: VPageIndicatorStandardUIModel = .init()
        
        uiModel.layout.direction = layout.direction
        uiModel.layout.dotDimension = layout.dotDimension
        uiModel.layout.unselectedDotScale = layout.unselectedDotScaleForStandardConfiguration
        uiModel.layout.spacing = layout.spacing
        
        uiModel.colors = colors
        
        uiModel.animations = animations
        
        return uiModel
    }
    
    var compactSubModel: VPageIndicatorCompactUIModel {
        var uiModel: VPageIndicatorCompactUIModel = .init()
        
        uiModel.layout.direction = layout.direction
        uiModel.layout.visibleDots = layout.visibleDots
        uiModel.layout.centerDots = layout.centerDots
        uiModel.layout.dotDimension = layout.dotDimension
        uiModel.layout.edgeDotScale = layout.edgeDotScaleForCompactConfiguration
        
        uiModel.colors = colors
        
        uiModel.animations = animations
        
        return uiModel
    }
}
