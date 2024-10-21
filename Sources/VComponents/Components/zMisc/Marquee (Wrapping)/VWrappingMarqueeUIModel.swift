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
public struct VWrappingMarqueeUIModel: Sendable {
    // MARK: Properties - Global
    /// Scroll direction. Set to `leftToRight`.
    public var scrollDirection: LayoutDirection = .leftToRight

    /// Spacing between wrapped content. Set to `20`.
    ///
    /// If `inset` is set to non-`0` value or `VWrappingMarqueeUIModel.insettedGradientMask` is used,
    /// it's better to set `spacing` to `0`.
    public var spacing: CGFloat = 20

    /// Content inset. Set to `0`.
    ///
    /// Alternately, use `insettedGradientMask` instance of `VWrappingMarqueeUIModel`.
    ///
    /// For best result, should be greater than or equal to `gradientMaskWidth`.
    public var inset: CGFloat = 0

    /// Horizontal alignment for non-scrolling stationary content. Set to `leading`.
    public var alignmentStationary: HorizontalAlignment = .leading

    // MARK: Properties - Gradient
    /// Gradient mask width. Set to `0`.
    ///
    /// To hide gradient mask, set to `0`.
    ///
    /// Alternately, use `insettedGradientMask` instance of `VBouncingMarqueeUIModel`.
    ///
    /// For best result, should be less than or equal to `inset`.
    public var gradientMaskWidth: CGFloat = 0

    /// Gradient mask opacity at the edge of the container. Set to `0`.
    public var gradientMaskOpacityContainerEdge: CGFloat = 0

    /// Gradient mask opacity at the edge of the content. Set to `1`.
    public var gradientMaskOpacityContentEdge: CGFloat = 1

    // MARK: Properties - Transition
    /// Animation curve. Set to `linear`.
    public var animationCurve: BasicAnimation.AnimationCurve = .linear

    /// Animation duration type. Set to `default`.
    public var animationDurationType: MarqueeDurationType = .default

    /// Animation delay. Set to `1` second.
    public var animationDelay: Double = 1

    /// Initial animation delay. Set to `1` second.
    public var animationInitialDelay: Double = 1
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}
}

// MARK: - Factory
extension VWrappingMarqueeUIModel {
    /// `VWrappingMarqueeUIModel` that insets content and applies fading gradient.
    public static var insettedGradientMask: Self {
        var uiModel: Self = .init()
        
        uiModel.spacing = 0
        uiModel.inset = 20
        
        uiModel.gradientMaskWidth = 20
        
        return uiModel
    }
}
