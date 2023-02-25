//
//  VPageIndicatorAutomaticUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.02.23.
//

import SwiftUI

// MARK: - V Page Indicator Automatic UI Model
/// Model that describes UI.
public struct VPageIndicatorAutomaticUIModel {
    // MARK: Properties
    fileprivate static let pageIndicatorFiniteReference: VPageIndicatorFiniteUIModel = .init()
    fileprivate static let pageIndicatorInfiniteReference: VPageIndicatorInfiniteUIModel = .init()
    
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
        /// Axis. Defaults to `horizontal`.
        public var axis: Axis = pageIndicatorFiniteReference.layout.axis
        
        /// Number of visible dots. Default to `7`.
        ///
        /// Must be odd and greater than `centerDots`, otherwise a `fatalError` will occur.
        public var visibleDots: Int = pageIndicatorInfiniteReference.layout.visibleDots
        
        /// Number of center dots. Default to `7`.
        ///
        /// Must be odd and less than `visibleDots`, otherwise a `fatalError` will occur.
        public var centerDots: Int = pageIndicatorInfiniteReference.layout.centerDots
        
        /// Limit after with `finite` configuration turns to `infinite` one. Defaults to `10`.
        public var finiteDotLimit: Int = 10
        
        /// Dot dimension. Defaults to `10`.
        public var dotDimension: CGFloat = pageIndicatorFiniteReference.layout.dotDimension

        /// Unselected dot scale during `finite` configuration. Defaults to `0.85`.
        public var unselectedDotScaleForFiniteConfiguration: CGFloat = pageIndicatorFiniteReference.layout.unselectedDotScale
        
        /// Scale of dot at the edge during `infinite` configuration. Defaults to `0.5`.
        ///
        /// If there are `7` visible dots, and `3` center dots, scales would sit at `[0.5, 0.75, 1, 1, 1, 0.75, 0.5]`.
        public var edgeDotScaleForInfiniteConfiguration: CGFloat = pageIndicatorInfiniteReference.layout.edgeDotScale
        
        /// Dot spacing. Defaults to `5`.
        public var spacing: CGFloat = pageIndicatorFiniteReference.layout.spacing
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VPageIndicatorFiniteUIModel.Colors

    // MARK: Animations
    /// Sub-model containing animation properties.
    public typealias Animations = VPageIndicatorFiniteUIModel.Animations
    
    // MARK: Sub-Models
    var finiteSubModel: VPageIndicatorFiniteUIModel {
        var uiModel: VPageIndicatorFiniteUIModel = .init()
        
        uiModel.layout.axis = layout.axis
        uiModel.layout.dotDimension = layout.dotDimension
        uiModel.layout.unselectedDotScale = layout.unselectedDotScaleForFiniteConfiguration
        uiModel.layout.spacing = layout.spacing
        
        uiModel.colors = colors
        
        uiModel.animations = animations
        
        return uiModel
    }
    
    var infiniteSubModel: VPageIndicatorInfiniteUIModel {
        var uiModel: VPageIndicatorInfiniteUIModel = .init()
        
        uiModel.layout.axis = layout.axis
        uiModel.layout.visibleDots = layout.visibleDots
        uiModel.layout.centerDots = layout.centerDots
        uiModel.layout.dotDimension = layout.dotDimension
        uiModel.layout.edgeDotScale = layout.edgeDotScaleForInfiniteConfiguration
        
        uiModel.colors = colors
        
        uiModel.animations = animations
        
        return uiModel
    }
}
