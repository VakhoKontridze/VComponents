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
    public static let primaryButtonModel: VPrimaryButtonModel = .init()
    public static let toggleModel: VToggleModel = .init()
    
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
            enabled: VSliderModel.toggleModel.colors.fill.off,
            disabled: VSliderModel.toggleModel.colors.fill.disabled
        )
        
        public var progress: StateColors = .init(
            enabled: VSliderModel.toggleModel.colors.fill.on,
            disabled: VSliderModel.primaryButtonModel.colors.background.disabled
        )
        
        public init() {}
    }
}

extension VSliderModel.Colors {
    public struct ThumbColors {
        public var fill: StateColors = .init(
            enabled: VSliderModel.toggleModel.colors.thumb.on,
            disabled: VSliderModel.toggleModel.colors.thumb.on
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
    public struct StateColors {
        public var enabled: Color
        public var disabled: Color
        
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        func `for`(_ state: VSliderState) -> Color {
            switch state {
            case .enabled: return enabled
            case .disabled: return disabled
            }
        }
    }
}

// MARK:- Animations
extension VSliderModel {
    public struct Animations {
        public var progress: Animation? = nil
        
        public init() {}
    }
}
