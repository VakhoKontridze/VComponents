//
//  VRangeSliderUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/12/21.
//

import SwiftUI

// MARK: - V Range Slider UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VRangeSliderUIModel {
    // MARK: Properties
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
        /// Slider height. Set to `10`.
        public var height: CGFloat = GlobalUIModel.Common.barHeight
        
        /// Slider corner radius. Set to `5`.
        public var cornerRadius: CGFloat = GlobalUIModel.Common.barCornerRadius
        
        /// Thumb dimension. Set to `20`.
        ///
        /// To hide thumb, set to `0`.
        public var thumbDimension: CGFloat = GlobalUIModel.ValuePickers.sliderThumbDimension
        
        /// Thumb corner radius. Set to `10`.
        public var thumbCornerRadius: CGFloat = GlobalUIModel.ValuePickers.sliderThumbCornerRadius
        
        /// Thumb border widths. Set to `0` for `iOS`, and `1` scaled to screen for `macOS`..
        ///
        /// To hide border, set to `0`.
        public var thumbBorderWidth: CGFloat = {
#if os(iOS)
            return 0
#elseif os(macOS)
            return 1/MultiplatformConstants.screenScale
#else
            fatalError() // Not supported
#endif
        }()
        
        /// Thumb shadow radius. Set to `2` for `iOS`, and `1` for `macOS`.
        public var thumbShadowRadius: CGFloat = GlobalUIModel.ValuePickers.sliderThumbShadowRadius
        
        /// Thumb shadow offset. Set to `0x2` for `iOS`, and `0x1` for `macOS`.
        public var thumbShadowOffset: CGSize = GlobalUIModel.ValuePickers.sliderThumbShadowOffset
        
        // MARK: Initializers
        /// Initializes UI model with default values.
        public init() {}
    }
    
    // MARK: Colors
    /// Model that contains color properties.
    public typealias Colors = VSliderUIModel.Colors
    
    // MARK: Animations
    /// Model that contains animation properties.
    public typealias Animations = VSliderUIModel.Animations
}
