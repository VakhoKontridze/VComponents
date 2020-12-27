//
//  VSliderModelStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider Model Standard
public struct VSliderModelStandard {
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
extension VSliderModelStandard {
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
extension VSliderModelStandard {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let thumbDimension: CGFloat
        public let thumbCornerRadius: CGFloat
        public let thumbBorderWidth: CGFloat
        public let thumbShadowRadius: CGFloat
        
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
        }
    }
}

// MARK:- Colors
extension VSliderModelStandard {
    public struct Colors {
        public let slider: Slider
        public let thumb: Thumb
        
        public init(
            slider: Slider = .init(),
            thumb: Thumb = .init()
        ) {
            self.slider = slider
            self.thumb = thumb
        }
    }
}

extension VSliderModelStandard.Colors {
    public struct Slider {
        public let progress: ProgressColors
        public let track: TrackColors
        
        public init(
            progress: ProgressColors = .init(),
            track: TrackColors = .init()
        ) {
            self.progress = progress
            self.track = track
        }
    }
}

extension VSliderModelStandard.Colors.Slider {
    public struct ProgressColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderStandard.Progress.enabled,
            disabled: Color = .clear//ColorBook.SliderStandard.Progress.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct TrackColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderStandard.Track.enabled,
            disabled: Color = .clear//ColorBook.SliderStandard.Track.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

extension VSliderModelStandard.Colors {
    public struct Thumb {
        public let fill: FillColors
        public let stroke: StrokeColors
        public let shadow: ShadowColors
        
        public init(
            fill: FillColors = .init(),
            stroke: StrokeColors = .init(),
            shadow: ShadowColors = .init()
        ) {
            self.fill = fill
            self.stroke = stroke
            self.shadow = shadow
        }
    }
}

extension VSliderModelStandard.Colors.Thumb {
    public struct FillColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderStandard.ThumbFill.enabled,
            disabled: Color = .clear//ColorBook.SliderStandard.ThumbFill.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct StrokeColors {
        public let enabled: Color
        public let disabled: Color

        public init(
            enabled: Color = .clear,//ColorBook.SliderStandard.ThumbBorder.enabled,
            disabled: Color = .clear//ColorBook.SliderStandard.ThumbBorder.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct ShadowColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = .clear,//ColorBook.SliderStandard.ThumbShadow.enabled,
            disabled: Color = .clear//ColorBook.SliderStandard.ThumbShadow.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderModelStandard.Colors {
    func progressColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return slider.progress.enabled
        case .disabled: return slider.progress.disabled
        }
    }

    func trackColor(state: VSliderState) -> Color {
        switch state {
        case .enabled: return slider.track.enabled
        case .disabled: return slider.track.disabled
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
        case .enabled: return thumb.stroke.enabled
        case .disabled: return thumb.stroke.disabled
        }
    }
    
    func thumbShadow(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.shadow.enabled
        case .disabled: return thumb.shadow.disabled
        }
    }
}
