//
//  VRangeSliderUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - V Range Slider UI Model
/// Model that describes UI.
public struct VRangeSliderUIModel {
    // MARK: Properties
    fileprivate static let sliderReference: VSliderUIModel = .init()
    
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
        /// Slider height. Defaults to `10`.
        public var height: CGFloat = sliderReference.layout.height
        
        /// Slider corner radius. Defaults to `5`.
        public var cornerRadius: CGFloat = sliderReference.layout.cornerRadius
        
        /// Thumb dimension. Defaults to `20`.
        public var thumbDimension: CGFloat = sliderReference.layout.thumbDimension
        
        /// Thumb corner radius. Defaults to `10`.
        public var thumbCornerRadius: CGFloat = sliderReference.layout.thumbCornerRadius
        
        /// Thumb border widths. Defaults to `0`.
        public var thumbBorderWidth: CGFloat = sliderReference.layout.thumbBorderWidth
        
        /// Thumb shadow radius. Defaults to `2`.
        public var thumbShadowRadius: CGFloat = sliderReference.layout.thumbShadowRadius
        
        // MARK: Initializers
        /// Initializes sub-model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Sub-model containing color properties.
    public typealias Colors = VSliderUIModel.Colors
    
    // MARK: Animations
    /// Sub-model containing animation properties.
    public typealias Animations = VSliderUIModel.Animations
}
