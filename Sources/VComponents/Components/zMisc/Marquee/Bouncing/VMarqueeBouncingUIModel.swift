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
        /// Scroll direction. Defaults to `leftToRight`.
        ///
        /// Can be modified to support right-to-left languages.
        public var direction: LayoutDirection = marqueeWrappingReference.layout.direction
        
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
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VMarqueeWrappingUIModel.Colors
    
    // MARK: Animations
    /// Sub-model containing animation properties.
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
