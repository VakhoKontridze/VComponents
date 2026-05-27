//
//  VBouncingMarqueeAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

public import SwiftUI
public import VCore

/// Model that describes appearance.
public struct VBouncingMarqueeAppearance {
    // MARK: Properties - Global
    /// Scroll direction.
    public var scrollDirection: LayoutDirection = .leftToRight

    /// Content inset.
    ///
    /// Ideal for text content.
    /// Alternately, use `insettedGradientMask` instance of `VBouncingMarqueeAppearance`.
    ///
    /// For best result, should be greater than or equal to `gradientMaskWidth`.
    public var inset: CGFloat = 0

    /// Horizontal alignment for non-scrolling stationary content.
    public var alignmentStationary: HorizontalAlignment = .leading

    // MARK: Properties - Gradient
    /// Gradient mask width.
    ///
    /// To hide gradient mask, set to `0`.
    ///
    /// Alternately, use `insettedGradientMask` instance of `VBouncingMarqueeAppearance`.
    ///
    /// For best result, should be less than or equal to `inset`.
    public var gradientMaskWidth: CGFloat = 0

    /// Gradient mask opacity at the edge of the container.
    public var gradientMaskOpacityContainerEdge: CGFloat = 0

    /// Gradient mask opacity at the edge of the content.
    public var gradientMaskOpacityContentEdge: CGFloat = 1

    // MARK: Properties - Transition
    /// Animation curve.
    public var animationCurve: BasicAnimation.AnimationCurve = .linear

    /// Animation duration type.
    public var animationDurationType: MarqueeDurationType = .default

    /// Animation delay.
    public var animationDelay: Double = 1

    /// Initial animation delay.
    public var animationInitialDelay: Double = 1
    
    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}
}

extension VBouncingMarqueeAppearance {
    /// `VBouncingMarqueeAppearance` that insets content and applies fading gradient.
    public static var insettedGradientMask: Self {
        var appearance: Self = .init()
        
        appearance.inset = 20
        
        appearance.gradientMaskWidth = 20
        
        return appearance
    }
}
