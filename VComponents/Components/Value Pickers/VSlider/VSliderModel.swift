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
    public var animation: Animation? = nil
    
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
        public static let primaryButtonColors: VPrimaryButtonModel.Colors = .init()
        public static let toggleColors: VToggleModel.Colors = .init()
        
        public var slider: SliderColors = .init()
        public var thumb: ThumbColors = .init()
        
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
    }
}

extension VSliderModel.Colors {
    public struct SliderColors {
        public var track: StateColors = .init(
            enabled: VSliderModel.Colors.toggleColors.fill.off,
            disabled: VSliderModel.Colors.toggleColors.fill.disabled
        )
        
        public var progress: StateColors = .init(
            enabled: VSliderModel.Colors.toggleColors.fill.on,
            disabled: VSliderModel.Colors.primaryButtonColors.background.disabled
        )
        
        public init() {}
    }
}

extension VSliderModel.Colors {
    public struct ThumbColors {
        public var fill: StateColors = .init(
            enabled: VSliderModel.Colors.toggleColors.thumb.on,
            disabled: VSliderModel.Colors.toggleColors.thumb.on
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

// MARK:- ViewModel
extension VSliderModel.Colors {
    func trackColor(state: VSliderState) -> Color {
        color(for: state, from: slider.track)
    }
    
    func progressColor(state: VSliderState) -> Color {
        color(for: state, from: slider.progress)
    }
    
    func thumbFillColor(state: VSliderState) -> Color {
        color(for: state, from: thumb.fill)
    }
    
    func thumbBorderWidth(state: VSliderState) -> Color {
        color(for: state, from: thumb.border)
    }
    
    func thumbShadow(state: VSliderState) -> Color {
        color(for: state, from: thumb.shadow)
    }
    
    private func color(for state: VSliderState, from colorSet: StateColors) -> Color {
        switch state {
        case .enabled: return colorSet.enabled
        case .disabled: return colorSet.disabled
        }
    }
}
