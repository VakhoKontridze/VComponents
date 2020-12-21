//
//  VSliderThumbModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider View Model
public struct VSliderThumbModel {
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
extension VSliderThumbModel {
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
extension VSliderThumbModel {
    public struct Layout {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        public let thumbDimension: CGFloat
        public let thumbCornerRadius: CGFloat
        let thumbShadowRadius: CGFloat
        
        public init(
            height: CGFloat = 10,
            cornerRadius: CGFloat = 5,
            thumbDimension: CGFloat = 20,
            thumbCornerRadius: CGFloat = 10
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.thumbDimension = thumbDimension
            self.thumbCornerRadius = thumbCornerRadius
            self.thumbShadowRadius = 2
        }
    }
}

// MARK:- Colors
extension VSliderThumbModel {
    // MARK: Properties
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

extension VSliderThumbModel.Colors {
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

extension VSliderThumbModel.Colors.Slider {
    public struct ProgressColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Progress.enabled,
            disabled: Color = ColorBook.Slider.Progress.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct TrackColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Track.enabled,
            disabled: Color = ColorBook.Slider.Track.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

extension VSliderThumbModel.Colors {
    public struct Thumb {
        public let fill: FillColors
        public let shadow: ShadowColors
        
        public init(
            fill: FillColors = .init(),
            shadow: ShadowColors = .init()
        ) {
            self.fill = fill
            self.shadow = shadow
        }
    }
}

extension VSliderThumbModel.Colors.Thumb {
    public struct FillColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Thumb.enabled,
            disabled: Color = ColorBook.Slider.Thumb.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
    
    public struct ShadowColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.Shadow.enabled,
            disabled: Color = ColorBook.Slider.Shadow.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderThumbModel.Colors {
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
    
    func thumbShadow(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.shadow.enabled
        case .disabled: return thumb.shadow.disabled
        }
    }
}
