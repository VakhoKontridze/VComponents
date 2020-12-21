//
//  VSliderThumbModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI

// MARK:- V Slider View Model
public struct VSliderThumbModel {
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
extension VSliderThumbModel {
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
extension VSliderThumbModel {
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

extension VSliderThumbModel.Layout {
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

extension VSliderThumbModel.Layout {
    public struct Thumb {
        // MARK: Properties
        public let dimension: CGFloat
        public let cornerRadius: CGFloat
        let shadowRadius: CGFloat = 2
        
        // MARK: Initializers
        public init(dimension: CGFloat, cornerRadius: CGFloat) {
            self.dimension = dimension
            self.cornerRadius = cornerRadius
        }
        
        public init() {
            self.init(
                dimension: 20,
                cornerRadius: 10
            )
        }
    }
}

// MARK:- Colors
extension VSliderThumbModel {
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

extension VSliderThumbModel.Colors {
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

extension VSliderThumbModel.Colors.Slider {
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

extension VSliderThumbModel.Colors {
    public struct Thumb {
        // MARK: Properties
        public let fill: FillColors
        public let shadow: ShadowColors
        
        // MARK: Initializers
        public init(fill: FillColors = .init(), shadow: ShadowColors = .init()) {
            self.fill = fill
            self.shadow = shadow
        }
    }
}

extension VSliderThumbModel.Colors.Thumb {
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
    
    public struct ShadowColors {
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
                enabled: ColorBook.Slider.Shadow.enabled,
                disabled: ColorBook.Slider.Shadow.disabled
            )
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
