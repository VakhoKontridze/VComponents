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
    public var layout: Layout = .init()
    public var colors: Colors = .init()
    public var animations: Animations = .init()
    
    public init() {}
}

// MARK:- Layout
extension VSliderModel {
    public struct Layout {
        public var height: CGFloat = 10
        public var cornerRadius: CGFloat = 5
        
        public var thumbDimension: CGFloat = 20
        public var thumbCornerRadius: CGFloat = 10
        
        public var thumbBorderWidth: CGFloat = 0
        
        public var thumbShadowRadius: CGFloat = 2
        
        var hasThumb: Bool { thumbDimension > 0 }
        
        public init() {}
    }
}

// MARK:- Colors
extension VSliderModel {
    public struct Colors {
        public var slider: SliderColors = .init()
        public var thumb: ThumbColors = .init()
        
        public init() {}
    }
}

extension VSliderModel.Colors {
    public struct SliderColors {
        public var track: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.fill.off,
            disabled: VSliderModel.toggleReference.colors.fill.disabled
        )
        
        public var progress: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.fill.on,
            disabled: VSliderModel.primaryButtonReference.colors.background.disabled
        )
        
        public init() {}
    }
}

extension VSliderModel.Colors {
    public struct ThumbColors {
        public var fill: StateColors = .init(
            enabled: VSliderModel.toggleReference.colors.thumb.on,
            disabled: VSliderModel.toggleReference.colors.thumb.on
        )
        
        public var border: StateColors = .init(
            enabled: .init(componentAsset: "Slider.Thumb.Border.enabled"),
            disabled: .init(componentAsset: "Slider.Thumb.Border.disabled")
        )
        
        public var shadow: StateColors = .init(
            enabled: .init(componentAsset: "Slider.Thumb.Shadow.enabled"),
            disabled: .init(componentAsset: "Slider.Thumb.Shadow.disabled")
        )
        
        public init() {}
    }
}

extension VSliderModel.Colors {
    public typealias StateColors = StateColorsED
}

// MARK:- Animations
extension VSliderModel {
    public struct Animations {
        public var progress: Animation? = nil
        
        public init() {}
    }
}

// MARK:- References
extension VSliderModel {
    public static let primaryButtonReference: VPrimaryButtonModel = .init()
    public static let toggleReference: VToggleModel = .init()
}
