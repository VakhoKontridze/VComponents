//
//  VSliderSolidThumbModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Slider View Model
public struct VSliderSolidThumbModel {
    // MARK: Properties
    public let behavior: Behavior
    public let layout: Layout
    public let colors: Colors
    
    // MARK: Initializers
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
        // MARK: Properties
        public let animation: Animation?
        
        // MARK: Initializers
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
        // MARK: Properties
        public let slider: Slider
        public let thumb: Thumb
        
        // MARK: Initializers
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
        // MARK: Properties
        public let height: CGFloat
        public let cornerRadius: CGFloat
        
        // MARK: Initializers
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
        // MARK: Properties
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        
        public let stroke: CGFloat
        
        // MARK: Initializers
        public init(dimension: CGFloat, cornerRadius: CGFloat, stroke: CGFloat) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
            self.stroke = stroke
        }
        
        public init() {
            self.init(
                dimension: 20,
                cornerRadius: 10,
                stroke: 1
            )
        }
    }
}

// MARK:- Colors
extension VSliderSolidThumbModel {
    // MARK: Properties
    public struct Colors {
        // MARK: Properties
        public let slider: Slider
        public let thumb: Thumb
        
        // MARK: Initializers
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
        // MARK: Properties
        public let progress: ProgressColors
        public let track: TrackColors
        
        // MARK: Initializers
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
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Progress.enabled,
                disabled: ColorBook.Slider.Progress.disabled
            )
        }
    }
    
    public struct TrackColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Track.enabled,
                disabled: ColorBook.Slider.Track.disabled
            )
        }
    }
}

extension VSliderSolidThumbModel.Colors {
    public struct Thumb {
        // MARK: Properties
        public let fill: FillColors
        public let stroke: StrokeColors
        
        // MARK: Initializers
        public init(fill: FillColors = .init(), stroke: StrokeColors = .init()) {
            self.fill = fill
            self.stroke = stroke
        }
    }
}

extension VSliderSolidThumbModel.Colors.Thumb {
    public struct FillColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.Thumb.enabled,
                disabled: ColorBook.Slider.Thumb.disabled
            )
        }
    }
    
    public struct StrokeColors {
        // MARK: Properties
        public let enabled: Color
        public let disabled: Color
        
        // MARK: Initializers
        public init(enabled: Color, disabled: Color) {
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init() {
            self.init(
                enabled: ColorBook.Slider.ThumbStroke.enabled,
                disabled: ColorBook.Slider.ThumbStroke.disabled
            )
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
