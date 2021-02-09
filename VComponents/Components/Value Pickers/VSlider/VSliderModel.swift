//
//  VSliderModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Model
/// Model that describes UI
public struct VSliderModel {
    /// Sub-model containing layout properties
    public var layout: Layout = .init()
    
    /// Sub-model containing color properties
    public var colors: Colors = .init()
    
    /// Sub-model containing animation properties
    public var animations: Animations = .init()
    
    /// Initializes model with default values
    public init() {}
}

// MARK:- Layout
extension VSliderModel {
    /// Sub-model containing layout properties
    public struct Layout {
        /// Slider height. Defaults to `10`.
        public var height: CGFloat = 10
        
        /// Slider corner radius. Defaults to `5`.
        public var cornerRadius: CGFloat = 5
        
        /// Thumb dimension. Defaults to `20`.
        public var thumbDimension: CGFloat = 20
        
        /// Thumb corner radius. Defaults to `10`.
        public var thumbCornerRadius: CGFloat = 10
        
        /// Thumb border widths. Defaults to `0`.
        public var thumbBorderWidth: CGFloat = 0
        
        /// Thumb shadow radius. Defaults to `2`.
        public var thumbShadowRadius: CGFloat = 2
        
        var hasThumb: Bool { thumbDimension > 0 }
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- Colors
extension VSliderModel {
    /// Sub-model containing color properties
    public struct Colors {
        /// Slider track colors
        public var track: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.fill.off,
            disabled: VSliderModel.toggleReference.colors.fill.disabled
        )
        
        /// Slider progress colors
        public var progress: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.fill.on,
            disabled: VSliderModel.primaryButtonReference.colors.background.disabled
        )
        
        public var thumb: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.thumb.on,
            disabled: VSliderModel.toggleReference.colors.thumb.on
        )
        
        /// Thumb border colors
        public var thumbBorder: StateColors = .init(
            enabled: .init(componentAsset: "Slider.Thumb.Border.enabled"),
            disabled: .init(componentAsset: "Slider.Thumb.Border.disabled")
        )
        
        /// Thumb shadow colors
        public var thumbShadow: StateColors = .init(
            enabled: .init(componentAsset: "Slider.Thumb.Shadow.enabled"),
            disabled: .init(componentAsset: "Slider.Thumb.Shadow.disabled")
        )
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

extension VSliderModel.Colors {
    /// Sub-model containing colors for component states
    public typealias StateColors = StateColorsED
}

// MARK:- Animations
extension VSliderModel {
    /// Sub-model containing animation properties
    public struct Animations {
        /// Progress animation. Defaults to `nil`.
        public var progress: Animation? = nil
        
        /// Initializes sub-model with default values
        public init() {}
    }
}

// MARK:- References
extension VSliderModel {
    /// Reference to `VPrimaryButtonModel`
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    
    /// Reference to `VToggleModel`
    public static let toggleReference: VToggleModel = .init()
}
