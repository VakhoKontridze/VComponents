//
//  VWrappingMarqueeUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Wrapping Marquee UI Model
/// Model that describes UI.
public struct VWrappingMarqueeUIModel {
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
        /// Scroll direction. Set to `leftToRight`.
        public var scrollDirection: LayoutDirection = .leftToRight
        
        /// Spacing between wrapped content. Set to  `20`.
        ///
        /// If you set `inset` to non-`0` value or use `VWrappingMarqueeUIModel.insettedGradient`,
        /// it's better to set `spacing` to `0`.
        public var spacing: CGFloat = 20
        
        /// Content inset. Set to `0`.
        ///
        /// Ideal for text content.
        /// Alternately, use `insettedGradient` instance of `VWrappingMarqueeUIModel`.
        ///
        /// For best result, should be greater than or equal to `gradientWidth`.
        public var inset: CGFloat = 0
        
        /// Horizontal alignment for non-scrolling stationary content. Set to `leading`.
        public var alignmentStationary: HorizontalAlignment = .leading
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public struct Colors {
        // MARK: Properties
        /// Width of fading gradient. Set to  `0`.
        ///
        /// To hide gradient, set to `0`.
        ///
        /// Ideal for text content.
        /// Alternately, use `insettedGradient` instance of `VBouncingMarqueeUIModel`.
        ///
        /// For best result, should be less than or equal to `inset`.
        public var gradientWidth: CGFloat = 0
        
        /// Gradient color at the edge of the container.
        public var gradientColorContainerEdge: Color = ColorBook.layer
        
        /// Gradient color at the edge of the content.
        public var gradientColorContentEdge: Color = ColorBook.layer.opacity(0.01)
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Animations
    /// Model that contains animation properties.
    public struct Animations {
        // MARK: Properties
        /// Animation curve. Set to `linear`.
        public var curve: BasicAnimation.AnimationCurve = .linear
        
        /// Animation duration type. Set to `default`.
        public var durationType: DurationType = .default
        
        /// Animation delay. Set to `1` second.
        public var delay: Double = 1
        
        /// Initial animation delay. Set to `1` second.
        public var initialDelay: Double = 1
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
        
        // MARK: Duration Type
        /// Enum that represents animation duration, such as `duration` or `velocity`.
        public enum DurationType {
            // MARK: Cases
            /// Duration.
            case duration(Double)
            
            /// Velocity, that calculates duration based on the width of the content.
            case velocity(CGFloat)
            
            // MARK: Initializers
            /// Default value. Set to `velocity` of  `20`.
            public static var `default`: Self { .velocity(20) }
            
            // MARK: Helpers
            func duration(width: CGFloat) -> Double {
                switch self {
                case .velocity(let velocity): return width / velocity
                case .duration(let duration): return duration
                }
            }
        }
    }
}

// MARK: - Factory
extension VWrappingMarqueeUIModel {
    /// `VWrappingMarqueeUIModel` that insets content and applies fading gradient.
    ///
    /// Ideal for text content.
    public static var insettedGradient: Self {
        var uiModel: Self = .init()
        
        uiModel.layout.spacing = 0
        uiModel.layout.inset = 20
        
        uiModel.colors.gradientWidth = 20
        
        return uiModel
    }
}
