//
//  VSliderModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Model
public struct VSliderModel {
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    public init(
        behavior: Behavior = .init(),
        layout: Layout = .init(),
        colors: Colors = .init()
    ) {
        self.behavior = behavior
        self.layout = layout
        self.colors = colors
    }
}

// MARK:- Behavior
extension VSliderModel {
    public struct Behavior {
        public let animation: Animation?
        
        public init(
            animation: Animation? = nil
        ) {
            self.animation = animation
        }
    }
}

// MARK:- Layout
extension VSliderModel {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        public let thumbDimension: CGFloat
        public let thumbCornerRadius: CGFloat
        
        public let thumbBorderWidth: CGFloat
        
        public let thumbShadowRadius: CGFloat
        
        let hasThumb: Bool
        
        public init(
            height: CGFloat = 10,
            cornerRadius: CGFloat = 5,
            thumbDimension: CGFloat = 20,
            thumbCornerRadius: CGFloat = 10,
            thumbBorderWidth: CGFloat = 0,
            thumbShadowRadius: CGFloat = 2
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.thumbDimension = thumbDimension
            self.thumbCornerRadius = thumbCornerRadius
            self.thumbShadowRadius = thumbShadowRadius
            self.thumbBorderWidth = thumbBorderWidth
            self.hasThumb = thumbDimension > 0
        }
    }
}

// MARK:- Colors
extension VSliderModel {
    public struct Colors {
        public static let toggleColors: VToggleModel.Colors = .init()
        
        public let slider: SliderColors
        public let thumb: ThumbColors
        
        public init(
            slider: SliderColors = .init(),
            thumb: ThumbColors = .init()
        ) {
            self.slider = slider
            self.thumb = thumb
        }
    }
}

extension VSliderModel.Colors {
    public struct SliderColors {
        public let track: TrackColors
        public let progress: ProgressColors
        
        public init(
            track: TrackColors = .init(),
            progress: ProgressColors = .init()
        ) {
            self.track = track
            self.progress = progress
        }
    }
}

extension VSliderModel.Colors.SliderColors {
    public struct TrackColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = VSliderModel.Colors.toggleColors.fill.enabledOff,
            disabled: Color = VSliderModel.Colors.toggleColors.fill.enabledOff
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct ProgressColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = VSliderModel.Colors.toggleColors.fill.enabledOn,
            disabled: Color = VSliderModel.Colors.toggleColors.fill.enabledOn
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

extension VSliderModel.Colors {
    public struct ThumbColors {
        public let fill: FillColors
        public let border: BorderColors
        public let shadow: ShadowColors
        
        public init(
            fill: FillColors = .init(),
            border: BorderColors = .init(),
            shadow: ShadowColors = .init()
        ) {
            self.fill = fill
            self.border = border
            self.shadow = shadow
        }
    }
}

extension VSliderModel.Colors.ThumbColors {
    public struct FillColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = VSliderModel.Colors.toggleColors.thumb.enabledOn,
            disabled: Color = VSliderModel.Colors.toggleColors.thumb.enabledOn
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct BorderColors {
        public let enabled: Color
        public let disabled: Color

        public init(
            enabled: Color = .init(componentAsset: "Slider.Thumb.Border.enabled"),
            disabled: Color = .init(componentAsset: "Slider.Thumb.Border.disabled")
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct ShadowColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .init(componentAsset: "Slider.Thumb.Shadow.enabled"),
            disabled: Color = .init(componentAsset: "Slider.Thumb.Shadow.disabled")
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderModel.Colors {
    func trackColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return slider.track.enabled
        case .disabled: return slider.track.disabled
        }
    }
    
    func progressColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return slider.progress.enabled
        case .disabled: return slider.progress.disabled
        }
    }
    
    func thumbFillColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.fill.enabled
        case .disabled: return thumb.fill.disabled
        }
    }
    
    func thumbBorderWidth(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.border.enabled
        case .disabled: return thumb.border.disabled
        }
    }
    
    func thumbShadow(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.shadow.enabled
        case .disabled: return thumb.shadow.disabled
        }
    }
}
