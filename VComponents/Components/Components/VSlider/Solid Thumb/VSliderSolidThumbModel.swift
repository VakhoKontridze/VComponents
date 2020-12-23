//
//  VSliderSolidThumbModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Slider Solid Thumb Model
public struct VSliderSolidThumbModel {
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
extension VSliderSolidThumbModel {
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
extension VSliderSolidThumbModel {
    public struct Layout {
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

extension VSliderSolidThumbModel.Layout {
    public struct Slider {
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        public init(
            height: CGFloat = 10,
            cornerRadius: CGFloat = 5
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
        }
    }
}

extension VSliderSolidThumbModel.Layout {
    public struct Thumb {
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        public let stroke: CGFloat
        
        public init(
            dimension: CGFloat = 20,
            cornerRadius: CGFloat = 10,
            stroke: CGFloat = 1
        ) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
            self.stroke = stroke
        }
    }
}

// MARK:- Colors
extension VSliderSolidThumbModel {
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

extension VSliderSolidThumbModel.Colors {
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

extension VSliderSolidThumbModel.Colors.Slider {
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

extension VSliderSolidThumbModel.Colors {
    public struct Thumb {
        public let fill: FillColors
        public let stroke: StrokeColors
        
        public init(
            fill: FillColors = .init(),
            stroke: StrokeColors = .init()
        ) {
            self.fill = fill
            self.stroke = stroke
        }
    }
}

extension VSliderSolidThumbModel.Colors.Thumb {
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
    
    public struct StrokeColors {
        public let enabled: Color
        public let disabled: Color
        
        public init(
            enabled: Color = ColorBook.Slider.ThumbStroke.enabled,
            disabled: Color = ColorBook.Slider.ThumbStroke.disabled
        ) {
            self.enabled = enabled
            self.disabled = disabled
        }
    }
}

// MARK:- Mapping
extension VSliderSolidThumbModel.Colors {
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
    
    func thumbStroke(state: VSliderState) -> Color {
        switch state {
        case .enabled: return thumb.stroke.enabled
        case .disabled: return thumb.stroke.disabled
        }
    }
}
