//
//  VMarqueeBouncingUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Marquee Bouncing UI Model
/// Model that describes UI.
public struct VMarqueeBouncingUIModel {
    // MARK: Properties
    fileprivate static let marqueeWrappingReference: VMarqueeWrappingUIModel = .init()
    
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
        /// Scroll direction. Defaults to `leftToRight`.
        public var scrollDirection: LayoutDirection = marqueeWrappingReference.layout.scrollDirection
        
        /// Content inset. Defaults to `0`.
        ///
        /// Ideal for text content.
        /// Alternately, use `insettedGradient` instance of `VMarqueeBouncingUIModel`.
        ///
        /// For best result, should be greater than or equal to `gradientWidth`.
        public var inset: CGFloat = marqueeWrappingReference.layout.inset
        
        /// Horizontal alignment for non-scrolling stationary content. Defaults to `leading`.
        public var alignmentStationary: HorizontalAlignment = marqueeWrappingReference.layout.alignmentStationary
        
        // MARK: Initializers
        /// Initializes model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public typealias Colors = VMarqueeWrappingUIModel.Colors
    
    // MARK: Animations
    /// Model that contains animation properties.
    public typealias Animations = VMarqueeWrappingUIModel.Animations
}

// MARK: - Factory
extension VMarqueeBouncingUIModel {
    /// `VMarqueeBouncingUIModel` that insets content and applies fading gradient.
    ///
    /// Ideal for text content.
    public static var insettedGradient: VMarqueeBouncingUIModel {
        var uiModel: VMarqueeBouncingUIModel = .init()
        
        uiModel.layout.inset = 20
        
        uiModel.colors.gradientWidth = 20
        
        return uiModel
    }
}
