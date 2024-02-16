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
    // MARK: Properties - Global
    /// Scroll direction. Set to `leftToRight`.
    public var scrollDirection: LayoutDirection = .leftToRight

    /// Spacing between wrapped content. Set to `20`.
    ///
    /// If `inset` is set to non-`0` value or `VWrappingMarqueeUIModel.insettedGradient` is used,
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

    // MARK: Properties - Gradient
    /// Width of fading gradient. Set to `0`.
    ///
    /// To hide gradient, set to `0`.
    ///
    /// Ideal for text content.
    /// Alternately, use `insettedGradient` instance of `VBouncingMarqueeUIModel`.
    ///
    /// For best result, should be less than or equal to `inset`.
    public var gradientWidth: CGFloat = 0

    /// Gradient mask opacity at the edge of the container. Set to `0`.
    public var gradientMaskOpacityContainerEdge: CGFloat = 0

    /// Gradient mask opacity at the edge of the content. Set to `1`.
    public var gradientMaskOpacityContentEdge: CGFloat = 1

    // MARK: Properties - Transition
    /// Animation curve. Set to `linear`.
    public var animationCurve: BasicAnimation.AnimationCurve = .linear

    /// Animation duration type. Set to `default`.
    public var animationDurationType: DurationType = .default

    /// Animation delay. Set to `1` second.
    public var animationDelay: Double = 1

    /// Initial animation delay. Set to `1` second.
    public var animationInitialDelay: Double = 1
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Duration Type
    /// Enumeration that represents animation duration, such as `duration` or `velocity`.
    public enum DurationType {
        // MARK: Cases
        /// Duration.
        case duration(Double)

        /// Velocity, that calculates duration based on the width of the content.
        case velocity(CGFloat)

        // MARK: Properties
        func toDuration(width: CGFloat) -> Double {
            switch self {
            case .velocity(let velocity): width / velocity
            case .duration(let duration): duration
            }
        }

        // MARK: Initializers
        /// Default value. Set to `velocity` of `20`.
        public static var `default`: Self { .velocity(20) }
    }
}

// MARK: - Factory
extension VWrappingMarqueeUIModel {
    /// `VWrappingMarqueeUIModel` that insets content and applies fading gradient.
    ///
    /// Ideal for text content.
    public static var insettedGradient: Self {
        var uiModel: Self = .init()
        
        uiModel.spacing = 0
        uiModel.inset = 20
        
        uiModel.gradientWidth = 20
        
        return uiModel
    }
}
